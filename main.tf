# Configure the Fastly Provider
provider "fastly" {
  api_key = var.FASTLY_API_KEY
}

#### Fastly VCL Service - Start

resource "fastly_service_vcl" "frontend-vcl-service" {
  name = "ERL Testing"

  domain {
    name    = "dmichael-erl-testing.global.ssl.fastly.net"
    comment = "ERL Testing VCL Service"
  }
  
  backend {
    address = "http-me.glitch.me"
    name = "glitch"
    port    = 443
    use_ssl = true
    ssl_cert_hostname = "http-me.glitch.me"
    ssl_sni_hostname = "http-me.glitch.me"
    override_host = "http-me.glitch.me"
    shield = "chi-il-us"
  }

  snippet {
    name    = "Additional Debugging"
    content = "${file("${path.module}/vcl/additional_debugging.vcl")}"
    type    = "deliver"
    priority = 100
  }

  snippet {
    name    = "Timing Debugging"
    content = "${file("${path.module}/vcl/timing_debugging.vcl")}"
    type    = "fetch"
    priority = 100
  }

   snippet {
    name    = "Stash the Client IP"
    content = "${file("${path.module}/vcl/ip_override.vcl")}"
    type    = "recv"
    priority = 1
  }

  # Edge Rate Limiting Snippets - Start

  snippet {
    name = "Pageview Rate Count Check Init"
    content = "${file("${path.module}/vcl/init.vcl")}"
    type    = "init"
  }

  snippet {
    name    = "Univision Login Rate Limiting"
    content = "${file("${path.module}/vcl/increment_counter.vcl")}"
    type    = "recv"
    priority = 52
  }

  snippet {
    name    = "Debug Ratecounter"
    content = "${file("${path.module}/vcl/counter_debugging.vcl")}"
    type    = "deliver"
    priority = 100
  }

  snippet {
    name    = "Ratecounter Error"
    content = "${file("${path.module}/vcl/ratecounter_error.vcl")}"
    type    = "error"
    priority = 100
  }

  snippet {
    name    = "Do Not Cache Login"
    content = "${file("${path.module}/vcl/cache_controls.vcl")}"
    type    = "fetch"
    priority = 100
  }

  # Edge Rate Limiting Snippets - End

  dictionary {
    name    = "ratelimit_external_login"
  }

  logging_bigquery {
    dataset = "dmichael_fastly_logs"
    name = "BigQuery"
    project_id = "se-development-9566"
    table = "erl_testing"
    format = file("${path.module}/files/log-format.txt")
    email = var.FASTLY_BQ_EMAIL
    secret_key = var.FASTLY_BQ_SECRET_KEY
  }
}
