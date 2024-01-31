# Add VCL version when Fastly-Debug header is present
if ( req.http.Fastly-Debug ) {
    set resp.http.X-VCL-Version = req.vcl.version;
    set resp.http.Log-Fastly-Request:url = req.url;
    set resp.http.Log-Fastly-Request:method = req.method;
    set resp.http.Log-Fastly-Request:req_bknd = req.backend;
}