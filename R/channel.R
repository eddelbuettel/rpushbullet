##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2017  Seth Wenchel and Dirk Eddelbuettel
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

##' Details for a channel
##'
##' @param channel The name of a Pushbullet channel as a string
##' @param no_recent_pushes Should the returned returned object exclude recent pushs?
##' \code{FALSE} (the default) will return up to 10 pushes. \code{TRUE} will exclude them
##'
##' @return a list with infoabout a channel
##'
##' @examples
##' xkcd <- pbGetChannelInfo("xkcd", TRUE)
##' summary(xkcd)
pbGetChannelInfo  <- function(channel, no_recent_pushes=FALSE) {
    UseMethod("pbGetChannelInfo")
}

##' @rdname pbGetChannelInfo
pbGetChannelInfo.default<- function(channel, no_recent_pushes=FALSE){
    pbUrl <- paste0("https://api.pushbullet.com/v2/channel-info?tag=",
                    curl::curl_escape(channel),
                    "&no_recent_pushes=",tolower(no_recent_pushes))
    jsonres <- curl::curl_fetch_memory(pbUrl)
    .checkReturnCode(jsonres)
    res <- fromJSON(rawToChar(jsonres$content))
    class(res) <- c("pbChannelInfo", "list")
    invisible(res)
}

##' @rdname pbGetChannelInfo
##' @param x Default object for \code{print} method
##' @param ... Other optional arguments
print.pbChannelInfo<- function(x, ...) {
    cat("Pushbullet channel info list\n")
    print(str(x))
    invisible(x)
}

##' @rdname pbGetChannelInfo
##' @param object Default object for \code{summary} method
summary.pbChannelInfo <- function(object, ...) {
    cat("Pushbullet User summary for", object[["iden"]],"\n")
    cat(" Name:",object[["name"]],"\n",
        "Description: ",object[["description"]],"\n",
        "Subscriber Count: ",object[["subscriber_count"]], "\n")
    invisible(object)
}
