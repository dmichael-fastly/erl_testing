# Fastly Edge VCL configuration
variable "FASTLY_API_KEY" {
    type        = string
    description = "This is API key for the Fastly VCL edge configuration."
}

#### VCL Service variables - Start

variable "FASTLY_BQ_EMAIL" {
    type        = string
    description = "This is client_email for the GCP Service Account that connects to the BigQuery table."
}

variable "FASTLY_BQ_SECRET_KEY" {
    type        = string
    description = "This is private_key for the GCP Service Account that connects to the BigQuery table."
}

#### VCL Service variables - End
