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

##' Get info about a user
##' @inheritParams pbGetDevices
##' @return Invisibly returns info about a user
##' @export
##' @examples
##' me <- pbGetUser()
##' summary(me)
pbGetUser <- function(apikey=.getKey()) {
    UseMethod("pbGetUser")
}

##' @rdname pbGetUser
pbGetUser.default<- function(apikey=.getKey()) {
    jsonres <- curl::curl_fetch_memory("https://api.pushbullet.com/v2/users/me", .getCurlHandle(apikey))
    .checkReturnCode(jsonres)
    res <- fromJSON(rawToChar(jsonres$content))
    class(res) <- c("pbUser", "list")
    invisible(res)
}

##' @rdname pbGetUser
##' @param x Default object for \code{print} method
##' @param ... Other optional arguments
print.pbUser<- function(x, ...) {
    cat("Pushbullet user info list\n")
     print(str(x))
    invisible(x)
}

##' @rdname pbGetUser
##' @param object Default object for \code{summary} method
summary.pbUser <- function(object, ...) {
    cat("Pushbullet User summary for", object[["iden"]],"\n")
    cat(" Name:",object[["name"]],"\n",
        "Email: ",object[["email"]],"\n",
        "Account Created: ",object[["created"]], "\n")
    invisible(object)
}
