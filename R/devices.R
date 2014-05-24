##' Retrieve the list of devices registered for the given API key.
##'
##' This function invokes the \sQuote{devices} functionality of
##' the Pushbullet API; see \url{https://docs.pushbullet.com/v2/devices} for more
##' details.
##' @title Get registered Pushbullet devices
##' @param apikey The API key used to access the service. It can be
##' supplied as an argument here, or via the file
##' \code{~/.rpushbullet.json} which is read at package
##' initialization.
##' @return A JSON result record is return invisibly
##' @author Dirk Eddelbuettel
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
