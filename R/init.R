
##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2014 - 2015  Dirk Eddelbuettel <edd@debian.org>
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
    pb <- fromJSON(dotfile, simplify=FALSE)
    assign("pb", pb, envir=.pkgenv)
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

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")

    dotfile <- "~/.rpushbullet.json"
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        .parseResourceFile(dotfile)
    } else {
        txt <- paste("No file", dotfile, "found.\nConsider placing the",
                     "Pushbullet API key and your device id(s) there.")
        packageStartupMessage(txt)
        assign("pb", NULL, envir=.pkgenv)
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
