
pbGetDevices <- function(apikey) {

    if (missing(apikey)) {
        if (is.null(.pkgglobalenv$pb)) {
            stop("No 'apikey' argument provided, and no rc file found. Aborting.")
        }
        apikey <- .pkgglobalenv$pb["key"]
    }

    txt <- sprintf("curl -s %s -u %s:", "https://api.pushbullet.com/v2/devices", apikey)
    res <- system(txt, intern=TRUE)
    invisible(res)
}

# TODO: pbDelete(Devices)
