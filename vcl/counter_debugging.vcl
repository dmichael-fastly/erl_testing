if (fastly.ff.visits_this_service == 0 && req.http.fastly-debug) {
  set resp.http.X-Fastly-RC-10s-Count = ratecounter.rc.bucket.10s;
  set resp.http.X-Fastly-RC-20s-Count = ratecounter.rc.bucket.20s;
  set resp.http.X-Fastly-RC-30s-Count = ratecounter.rc.bucket.30s;
  set resp.http.X-Fastly-RC-40s-Count = ratecounter.rc.bucket.40s;
  set resp.http.X-Fastly-RC-50s-Count = ratecounter.rc.bucket.50s;
  set resp.http.X-Fastly-RC-60s-Count = ratecounter.rc.bucket.60s;
}