
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

.pkgenv <- new.env(parent=emptyenv())

.findDotfile <- function(filename=".rpushbullet.json", paths=c(".", "~"), firstOnly=TRUE, onMissing=c("pkgmessage", "warning", "error")) {
  onMissing <- match.arg(onMissing)
  pathnames <- file.path(paths, filename)
  pathnames <- pathnames[file_test("-f", pathnames)]

  if (length(pathnames) == 0L) {
    txt <- sprintf("No file %s found (directories searched: %s)\nConsider placing the Pushbullet API key and your device id(s) there.", sQuote(filename), paste(sQuote(paste0(paths, "/")), collapse=", "))
    if (onMissing == "pkgmessage") {
      packageStartupMessage(txt)
    } else if (onMissing == "message") {
      message(txt)
    } else if (onMissing == "warning") {
      warning(txt)
    } else if (onMissing == "error") {
      stop(txt)
    }
    ## Intentially returns NA_character_ if firstOnly=TRUE
  }
  if (firstOnly)
    pathnames <- pathnames[1L]
  pathnames
}

.parseDotfile <- function(...) {
    dotfile <- .findDotfile(...)
    if (!file.exists(dotfile)) {
        assign("pb", NULL, envir=.pkgenv)
        return(invisible(NULL))
    }

    packageStartupMessage("Reading ", dotfile)
    pb <- fromJSON(dotfile, simplify=FALSE)
    assign("pb", pb, envir=.pkgenv)

    if (is.null(pb[["key"]])) {
        warning("Field 'key' is either empty or missing: ", dotfile,
                call.=FALSE, immediate.=TRUE)
    }

    options("rpushbullet.key" = pb[["key"]])
    options("rpushbullet.devices" = pb[["devices"]])
    ## names is an optional entry, with fallback value of NULL
    options("rpushbullet.names" = pb[["names"]])
    ## defaultdevice is an optional entry, with fallback value of 0
    options("rpushbullet.defaultdevice" =
                if ("defaultdevice" %in% names(pb)) pb[["defaultdevice"]] else 0)
    ## these are for testing
    options("rpushbullet.testemail" =
                if ("testemail" %in% names(pb)) pb[["testemail"]] else character())
    options("rpushbullet.testchannel" =
                if ("testchannel" %in% names(pb)) pb[["testchannel"]] else character())

    invisible(pb)
}

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")

    curl <- Sys.which("curl")
    if (curl == "") {
        warning("No curl binary found in your path. Please consider installing curl.",
                call.=FALSE, immediate.=TRUE)
    } else {
        assign("curl", curl, envir=.pkgenv)
    }

    .parseDotfile()
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

.getCurl <- function() {
    curl <- .pkgenv$curl
    if (curl == "")
        stop(paste("No curl binary registered. ",
                   "Install curl, and restart R and reload package"), call.=FALSE)
    curl
}

.getNames <- function() {
    getOption("rpushbullet.names",       	# retrieve as option,
              if (!is.null(.pkgenv$pb)) 	# else try environment
                  .pkgenv$pb[["names"]]         # and use it, or signal error
              else stop(paste("Neither option 'rpushbullet.names' nor entry in",
                              "package environment found. Aborting."), call.=FALSE))
}

.getUploadRequest <- function(filename, filetype="img/png", apikey = .getKey()) {

    curl <- .getCurl()
    pburl <- "https://api.pushbullet.com/v2/upload-request"

    txt <- sprintf('%s -s -u %s: %s -d file_name="%s" -d file_type=%s',
                   curl, apikey, pburl, filename, filetype)

    result <- fromJSON(system(txt, intern=TRUE))
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
