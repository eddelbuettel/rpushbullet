
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

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")

    curl <- Sys.which("curl")
    if (curl == "") {
        warning("No curl binary found in your path. Please consider installing curl.")
    } else {
        assign("curl", curl, envir=.pkgenv)
    }
    
    dotfile <- "~/.rpushbullet.json"
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        pb <- fromJSON(dotfile)
        assign("pb", pb, envir=.pkgenv)
        options("rpushbullet.key" = pb[["key"]])
        options("rpushbullet.devices" = pb[["devices"]])
    } else {
        txt <- paste("No file", dotfile, "found.\nConsider placing the",
                     "Pushbullet API key and your device id(s) there.")
        packageStartupMessage(txt)
        assign("pb", NULL, envir=.pkgenv)
    }
}

.getKey <- function() {
    getOption("rpushbullet.key",                # retrieve as option, 
              ifelse(!is.null(.pkgenv$pb),      # else try environment
                     .pkgenv$pb[["key"]],       # and use it, or signal error
                     stop(paste("Neither option 'rpushbutton.key' nor entry in",
                                "package environment found. Aborting."), call.=FALSE)))
}

.getDevices <- function() {
    getOption("rpushbullet.devices",       	# retrieve as option, 
              ifelse(!is.null(.pkgenv$pb),	# else try environment
                     .pkgenv$pb[["devices"]],   # and use it, or signal error
                     stop(paste("Neither option 'rpushbutton.devices' nor entry in",
                                "package environment found. Aborting."), call.=FALSE)))
}

.getCurl <- function() {
    curl <- .pkgenv$curl
    if (curl == "") stop(paste("No curl binary registered. ",
                               "Install curl, and restart R and reload package"),
                         call.=FALSE)
    curl
}
