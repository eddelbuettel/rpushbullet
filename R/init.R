
##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2014 - 2017  Dirk Eddelbuettel <edd@debian.org>
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

.pkgenv <- new.env(parent=emptyenv())

.parseResourceFile <- function(dotfile="~/.rpushbullet.json") {
    pb <- fromJSON(dotfile, simplifyVector = FALSE)
    .pkgenv[["pb"]] <- pb
    if (is.null(pb[["key"]])) {
        warning("Field 'key' is either empty or missing: ", dotfile, call.=FALSE, immediate.=TRUE)
    }
    options("rpushbullet.key" = pb[["key"]])
    options("rpushbullet.devices" = pb[["devices"]])
    ## names is an optional entry, with fallback value of NULL
    options("rpushbullet.names" = pb[["names"]])
    ## defaultdevice is an optional entry, with fallback value of 0
    options("rpushbullet.defaultdevice" = if ("defaultdevice" %in% names(pb)) pb[["defaultdevice"]] else 0)
    ## these are for testing
    options("rpushbullet.testemail" = if ("testemail" %in% names(pb)) pb[["testemail"]] else character())
    options("rpushbullet.testchannel" = if ("testchannel" %in% names(pb)) pb[["testchannel"]] else character())
}

.getDotfile <- function() {
    getOption("rpushbullet.dotfile", default="~/.rpushbullet.json")
}

.onLoad <- function(libname, pkgname) {
    dotfile <- .getDotfile()
    if (file.exists(dotfile)) .parseResourceFile(dotfile)
}

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")
    dotfile <- .getDotfile()
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        .parseResourceFile(dotfile)
    } else {
        txt <- paste("No file", dotfile, "found. Consider placing the",
                     "Pushbullet API key and your device id(s) there.")
        txt <- paste(strwrap(txt), collapse="\n")
        packageStartupMessage(txt)
        .pkgenv[["pb"]] <- NULL
    }
}

.getKey <- function() {
    getOption("rpushbullet.key",                # retrieve as option,
              if (!is.null(.pkgenv$pb))         # else try environment
                  .pkgenv$pb[["key"]]           # and use it, or signal error
              else stop(paste("Neither option 'rpushbullet.key' nor entry in",
                              "package environment found. Aborting."), call.=FALSE))
}

.getDevices <- function() {
    getOption("rpushbullet.devices",       	# retrieve as option,
              if (!is.null(.pkgenv$pb))   	# else try environment
                  .pkgenv$pb[["devices"]]       # and use it, or signal error
              else stop(paste("Neither option 'rpushbullet.devices' nor entry in",
                              "package environment found. Aborting."), call.=FALSE))
}

.getDefaultDevice <- function() {
    getOption("rpushbullet.defaultdevice",     	# retrieve as option,
              if (!is.null(.pkgenv$pb) && 	# else try environment
                  "defaultdevice" %in% names(.pkgenv$pb))
                  .pkgenv$pb[["defaultdevice"]] # and use it, or return zero
              else 0)                           # as code for all devices
}

.getCurlHandle <- function(apikey){
    h <- curl::new_handle()
    curl::handle_setheaders(h, .list=list('Access-Token' = apikey))
    return(h)
}

.getNames <- function() {
    getOption("rpushbullet.names",       	# retrieve as option,
              if (!is.null(.pkgenv$pb)) 	# else try environment
                  .pkgenv$pb[["names"]]         # and use it, or signal error
              else stop(paste("Neither option 'rpushbullet.names' nor entry in",
                              "package environment found. Aborting."), call.=FALSE))
}

.getUploadRequest <- function(filename, filetype="img/png", apikey = .getKey()) {

    h <- .getCurlHandle(apikey)
    pburl <- "https://api.pushbullet.com/v2/upload-request"

    # txt <- sprintf('%s -s -u %s: %s -d file_name="%s" -d file_type=%s',
    #                curl, apikey, pburl, filename, filetype)

    form_list <- list(file_name=filename, file_type=filetype)
    curl::handle_setform(h, .list = form_list)
    res <- curl::curl_fetch_memory(pburl, h)
    result <- fromJSON(rawToChar(res$content))
    result
}

.getTestEmail <- function() {
    getOption("rpushbullet.testemail",     	# retrieve as option,
              if (!is.null(.pkgenv$pb) &&  	# else try environment
                  "testemail" %in% names(.pkgenv$pb))
                  .pkgenv$pb[["testemail"]]     # and use it, or
              else character())                 # return empty character()
}

.getTestChannel <- function() {
    getOption("rpushbullet.testchannel",     	# retrieve as option,
              if (!is.null(.pkgenv$pb) &&  	# else try environment
                  "testchannel" %in% names(.pkgenv$pb))
                  .pkgenv$pb[["testchannel"]]   # and use it, or
              else character())                 # return empty character()
}

##' warn if return type is not okay
##'
##' the general idea is that the user can set options(warn=2)
##' when simpleTests.R on travis or similar. note that file
##' pushes are a special case because of their two part call.
##' the first part returns code '204' on success but that is
##' checked in situ
##'
##' @param res the result of a call to curl::curl_fetch_memory
##'
##' @return NULL
##' @noRd
.checkReturnCode <- function(res) {
    code <- res$status_code
    if(code==200)
        return()
    msg <- switch(as.character(code),
                  `400` = ": Bad Request - Usually this results from missing a required parameter.",
                  `401` = ": Unauthorized - No valid access token provided.",
                  `403` = ": Forbidden - The access token is not valid for that request.",
                  `404` = ": Not Found - The requested item does not exist.",
                  `429` = ": Too Many Requests - You have been ratelimited for making too many requests to the server.",
                  ": Undocumented response code"
    )
    if(code>=500 && code<600)
        msg <- ": Server Error - Something went wrong on Pushbullet's side. If this error is from an intermediate server, it may not be valid JSON."
    warning(code,msg,call. = FALSE)
    return()
}
