if (req.http.x-vix-external-login-path) {
    set beresp.http.Cache-Control = "no-store";
}