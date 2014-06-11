
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
##' @return The resulting JSON record is converted to a list and
##' returned as a \code{pbDevices} object with appropriate
##' \code{print} and \code{summary} methods.
##' @author Dirk Eddelbuettel
pbGetDevices <- function(apikey=.getKey()) {
    UseMethod("pbGetDevices")
}

##' @rdname pbGetDevices
pbGetDevices.default <- function(apikey=.getKey()) {
    txt <- sprintf("%s -s %s -u %s:",
                   .getCurl(), "https://api.pushbullet.com/v2/devices", apikey)
    jsonres <- system(txt, intern=TRUE)
    res <- fromJSON(jsonres)
    class(res) <- c("pbDevices", "list")
    invisible(res)
}

##' @rdname pbGetDevices
##' @param x Default object for \code{print} method
##' @param ... Other optional arguments
print.pbDevices <- function(x, ...) {
    cat("Pushbullet device list\n")
    ## we ignore argument 1 which seems empty in all cases
    print(str(x[["devices"]]))
    invisible(x)
}

##' @rdname pbGetDevices
##' @param object Default object for \code{summary} method
summary.pbDevices <- function(object, ...) {
    cat("Pushbullet device summary for", length(object[["devices"]]), "devices ")
    cat("with these ids:\n", paste(sapply(object[["devices"]], "[", "iden"), collape=""), "\n")
    invisible(object)
}

# TODO: pbDelete(Devices)
