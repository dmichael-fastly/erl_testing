# Stash the Client IP
if (fastly.ff.visits_this_service == 0) {
  set req.http.Fastly-Client-IP = client.ip;
}