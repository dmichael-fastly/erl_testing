if ( req.http.Fastly-Debug ) {
    set beresp.http.log-timing:fetch = time.elapsed.usec;
    set beresp.http.log-timing:misspass = req.http.log-timing:misspass;
    set beresp.http.log-timing:do_stream = beresp.do_stream;

    if (req.backend.is_origin) {
        set beresp.http.log-origin:method = bereq.method;
        set beresp.http.log-origin:url = bereq.url;
        set beresp.http.log-origin:status = beresp.status;
        set beresp.http.log-origin:reason = beresp.response;
        set beresp.http.log-origin:shield = server.datacenter;
    }
}