if (fastly.ff.visits_this_service == 0 && req.restarts == 0) {
  unset req.http.x-vix-external-login-path;
  if (req.url ~ "^/v1/auth/token/external/login(.*)$") {
    set req.http.x-vix-external-login-path = req.url.path;
    set req.url = "/v1/auth/token/reg-user/login" + re.group.1;
  }
}

if (req.http.x-vix-external-login-path && (server.pop == "CHI" || server.pop == "IAD")) {
  declare local var.start_ratelimiting_count INTEGER;
  declare local var.last_minute INTEGER;
  declare local var.total_chances INTEGER;

  set req.http.x-log-message = "";

  # Each shield has its own origin, so the rate at which to start rate limiting may vary by which shield we are at
  if (server.pop == "CHI") {
    set var.start_ratelimiting_count = std.atoi(table.lookup(ratelimit_external_login, "start_ratelimiting_count_usce1", "50"));
  } else {
    set var.start_ratelimiting_count = std.atoi(table.lookup(ratelimit_external_login, "start_ratelimiting_count_usea1", "50"));
  }

  # Increment the counter by 1 for every login request so later on we can use the number of login requests in the last 10s
  set var.last_minute = ratelimit.ratecounter_increment(rc_external_logins, "login", 1);

  set req.http.x-log-message = req.http.x-log-message + " - " + "The current 10s rate is " ratecounter.rc_external_logins.bucket.10s;

  set var.total_chances = 1;
  # Check if we're over the rate at which to start rate limiting
  if (ratecounter.rc_external_logins.bucket.10s > var.start_ratelimiting_count) {
    set req.http.x-log-message = req.http.x-log-message + " - " + "Current 10s rate is > " var.start_ratelimiting_count;
    set var.total_chances = 2; # 1 out of 2 chance you are allowed through (1 out of 2 chance you get a 429)
  }
  set var.start_ratelimiting_count += var.start_ratelimiting_count;
  # Now we are going to increment the var.start_ratelimiting_count exponentially to determine the probability we should send a request a 429 response
  # Check if we're over twice the rate at which to start rate limiting
  if (ratecounter.rc_external_logins.bucket.10s > var.start_ratelimiting_count) {
    set req.http.x-log-message = req.http.x-log-message + " - " + "Current 10s rate is > " var.start_ratelimiting_count;
    set var.total_chances = 3; # 1 out of 3 chance you are allowed through (2 out of 3 chance you get a 429)
  }
  set var.start_ratelimiting_count += var.start_ratelimiting_count;
  # Check if we're over four times the rate at which to start rate limiting
  if (ratecounter.rc_external_logins.bucket.10s > var.start_ratelimiting_count) {
    set req.http.x-log-message = req.http.x-log-message + " - " + "Current 10s rate is > " var.start_ratelimiting_count;
    set var.total_chances = 4; # 1 out of 4 chance you are allowed through (3 out of 4 chance you get a 429)
  }
  if (var.total_chances > 1) {
    set req.http.x-log-message = req.http.x-log-message + " - " + "This request has a 1 out of " var.total_chances " chance of getting through";
    # We are at least over the rate at which to start rate limiting
    if (randomint(1, var.total_chances) != 1) {
      # This request has a 1 out of var.total_chances chance of making it through, the rest get a 429
      set req.http.x-log-message = req.http.x-log-message + " - " + "This request is getting a 429";
      error 620;
    }
  } else {
    set req.http.x-log-message = req.http.x-log-message + " - " + "This request is guaranteed to go through";
  }
}