if (obj.status == 620) {
    set obj.status = 429;
    set obj.response = "Too many requests";
    set obj.http.content-type = "application/json";
    synthetic {json"{"status": "fail","data":{"error": "too many requests"}}"json};
    return(deliver);
}