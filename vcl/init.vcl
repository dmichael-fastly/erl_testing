ratecounter rc { }

sub increment_pageview_counter {
  if (std.tolower(req.url) !~ "\.(aif|aiff|au|avi|bin|bmp|cab|carb|cct|cdf|class|css|dcr|doc|dtd|exe|flv|gcf|gff|gif|grv|hdml|hqx|ico|ini|jpeg|jpg|js|mov|mp3|mp4|nc|pct|pdf|png|ppc|pws|svg|swa|swf|txt|vbs|w32|wav|wbmp|wml|wmlc|wmls|wmlsc|xsd|zip|webp|woff|woff2|ttf|bz2|gz|tgz|tar|pem|cer|sql|xml|dat|pub|log|json|md|bak|rar|eml|lzma|war|bz|7z)($|\?)") {
    declare local var.last_minute INTEGER;
    set var.last_minute = ratelimit.ratecounter_increment(rc, req.http.Fastly-Client-IP, 1);
  }
}
