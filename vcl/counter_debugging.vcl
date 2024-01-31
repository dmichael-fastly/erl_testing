if (req.http.fastly-debug && !resp.http.X-Fastly-RC-10s-Count) {
  set resp.http.X-Fastly-RC-10s-Count = ratecounter.rc_external_logins.bucket.10s;
  set resp.http.X-Fastly-RC-20s-Count = ratecounter.rc_external_logins.bucket.20s;
  set resp.http.X-Fastly-RC-30s-Count = ratecounter.rc_external_logins.bucket.30s;
  set resp.http.X-Fastly-RC-40s-Count = ratecounter.rc_external_logins.bucket.40s;
  set resp.http.X-Fastly-RC-50s-Count = ratecounter.rc_external_logins.bucket.50s;
  set resp.http.X-Fastly-RC-60s-Count = ratecounter.rc_external_logins.bucket.60s;
}