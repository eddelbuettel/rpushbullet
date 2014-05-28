
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
##' @return A JSON result record is return invisibly
##' @author Dirk Eddelbuettel
pbGetDevices <- function(apikey=.getKey()) {
    txt <- sprintf("curl -s %s -u %s:", "https://api.pushbullet.com/v2/devices", apikey)
    res <- system(txt, intern=TRUE)
    invisible(res)
}

# TODO: pbDelete(Devices)
