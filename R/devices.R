
##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2014  Dirk Eddelbuettel <edd@debian.org>
##
##  This file is part of RPushbullet.
##
##  RPushbullet is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  RPushbullet is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with RPushbullet.  If not, see <http://www.gnu.org/licenses/>.

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
##' @param ignore.pushable Pushbullet includes a 'pushable' flag in
##' its list of devices, flagging a device as false if the device has
##' been deleted or for some reason disabled. Setting
##' \sQuote{ignore.pushable=TRUE} will ignore this behavior and include all
##' devices.
##' @param use Save the results to the options ("rpushbullet.key",
##' "rpushbullet.devices", and "rpushbullet.defaultdevice"). Doing
##' this does not last past this R session; for that, either manually
##' assign the options in your \code{~/.Rprofile} or save them in
##' \code{~/.rpushbullet.json} via `pbSaveConfig()`.
##' @return The resulting JSON record is converted to a list and
##' returned as a \code{pbDevices} object with appropriate
##' \code{print} and \code{summary} methods.
##' @author Dirk Eddelbuettel
pbGetDevices <- function(apikey=.getKey(), ignore.pushable=FALSE, use=TRUE) {
    UseMethod("pbGetDevices")
}

##' @rdname pbGetDevices
pbGetDevices.default <- function(apikey=.getKey(), ignore.pushable=FALSE, use=TRUE) {
    txt <- sprintf("%s -s %s -u %s:",
                   .getCurl(), "https://api.pushbullet.com/v2/devices", apikey)
    jsonres <- system(txt, intern=TRUE)
    res <- fromJSON(jsonres)
    if ('error' %in% names(res)) {
        stop(paste("Pushbullet error:", paste(res$error, collapse=' ')), call.=FALSE)
    } else {
        devices <-
            if (ignore.pushable) res
            else Filter(function(d) d$pushable, res$devices)
        if (length(devices)) {
            res <- list(key = apikey,
                        devices = lapply(devices, `[`, c('iden', 'nickname')),
                        defaultdevice = 0)
        } else {
            stop("Pushbullet: no pushable devices returned, use `ignore.pushable=TRUE` to use them anyway")
        }
    }
    if (use) {
        assign("pb", res, envir=.pkgenv)
        options("rpushbullet.key" = apikey)
        options("rpushbullet.devices" = res$devices)
        options("rpushbullet.defaultdevice" = res$defaultdevice)
    }
    class(res) <- c("pbDevices", "list")
    invisible(res)
}

##' @rdname pbGetDevices
##' @param x Default object for \code{print} method
##' @param ... Other optional arguments
print.pbDevices <- function(x, ...) {
    cat("Pushbullet device list\n")
    ## we ignore argument 1 which seems empty in all cases
    cat(str(x[["devices"]]))
    invisible(x)
}

##' @rdname pbGetDevices
##' @param object Default object for \code{summary} method
summary.pbDevices <- function(object, ...) {
    addDefault <- ''
    if (object$defaultdevice) {
        object$devices[[object$defaultdevice]]$nickname <-
            paste0('*', object$devices[[object$defaultdevice]]$nickname)
        addDefault <- '(* == default)'
    }
    cat("Pushbullet device summary for", length(object[["devices"]]), "devices ")
    cat("with these ids", addDefault, ":\n", paste(sapply(object[["devices"]], "[", "nickname"), collape=""), "\n")
    invisible(object)
}

##' Save the pushbullet account information to a file.
##'
##' The default behavior of other rpushbullet functions relies solely
##' on the apikey and device list being accessible via
##' \sQuote{options()}. This information can be cached in a local file
##' and recalled when the library is loaded.
##'
##' The default file is \sQuote{~/.rpushbullet.json}, though any file
##' can be provided; note that the default filename is opened when the
##' library is attached, otherwise you'll need to manually load it
##' with \sQuote{pbLoadConfig()}.
##'
##' If file is not provided then the string that would be saved to it
##' is printed to the console.
##' @param apikey  The API key used to access the service.
##' @param devices The devices stored as potential recipients.
##' @param defaultdevice The default recipient device for posts. See `pbPost` for details.
##' @param file File to save the information to.
##' @param overwrite boolean. Whether overwrite the file if it already exists; if TRUE, all data in the file is lost
##' @return The list of apikey, devices, and defaultdevice, invisibly.
pbSaveConfig <- function(apikey, devices, defaultdevice, file="", overwrite=FALSE) {
    if (missing(apikey))
        apikey <- .getKey()
    if (missing(devices))
        devices <- .getDevices()
    if (missing(defaultdevice))
        defaultdevice <- .getDefaultDevice()
    listForSaving <- list(key = apikey,
                          devices = devices,
                          defaultdevice = defaultdevice)
    if (file == "")
        file <- stdout()
    else if (is.character(file)) {
        if (file.exists(file) && !overwrite)
            stop("file exists, aborting.")
        file <- file(file, "w")
        on.exit(close(file))
    } else if (! isOpen(file, "w")) {
        open(file, "w")
        on.exit(close(file))
    }
    if (!inherits(file, "connection"))
        stop("`file` must be a character string or connection")
    writeLines(text=toJSON(listForSaving, pretty=TRUE), con=file)
    class(listForSaving) <- c('pbDevices', 'list')
    invisible(listForSaving)
}

##' Load the pushbullet account information from a file.
##'
##' @param file File to load the information from.
##' @param text If 'file' is not supplied and this is a character
##' string, then data are read from the value of 'text' via a text
##' connection.
##' @param use Whether to save the read list in the environment for
##' use (TRUE) or just return what was read (FALSE, more for
##' debugging).
##' @return The list of apikey, devices, and defaultdevice, invisibly.
pbLoadConfig <- function(file, text, use=TRUE) {
    if (missing(file) && !missing(text)) {
        file <- textConnection(text)
        on.exit(close(file))
    }
    if (is.character(file)) {
        file <- file(file, 'rt')
        on.exit(close(file))
    }
    if (!inherits(file, 'connection'))
        stop("'file' must be a character string or connection")
    if (!isOpen(file, 'rt')) {
        open(file, 'rt')
        on.exit(close(file))
    }
    pb <- fromJSON(file, simplify=FALSE)
    assign("pb", pb, envir=.pkgenv)
    options("rpushbullet.key" = pb[["key"]])
    options("rpushbullet.devices" = pb[["devices"]])
    options("rpushbullet.defaultdevice" =
            ifelse("defaultdevice" %in% names(pb), pb[["defaultdevice"]], 0))
    class(pb) <- c('pbDevices', 'list')
    invisible(pb)
}

# TODO: pbDelete(Devices)
