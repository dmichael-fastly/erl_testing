# Stash the Client IP
if (fastly.ff.visits_this_service == 0) {
  if (req.http.X-Source-Ip) {
    set req.http.Fastly-Client-IP = req.http.X-Source-Ip;
  } else {
    set req.http.Fastly-Client-IP = client.ip;
  }
}