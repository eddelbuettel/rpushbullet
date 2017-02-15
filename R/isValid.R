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

##' Check if a key is valid
##'
##' @param apikey a string representing a Pushbullet API Token
##'
##' @return TRUE if the key appears to be associated with a valid user.
##' otherwise FALSE
##'
##' @noRd
##' @examples
##' ## TRUE, (probably)
##' RPushbullet:::.isValidKey(RPushbullet:::.getKey())
##'
##' ## FALSE
##' RPushbullet:::.isValidKey("josh")
.isValidKey <- function(apikey){
    jsonres <- curl::curl_fetch_memory("https://api.pushbullet.com/v2/users/me",
                                       .getCurlHandle(apikey))
    return(jsonres$status_code==200)
}

##' Check if device is associate with key
##'
##' @param apikey a string representing a Pushbullet API Token
##'
##' @return TRUE if the device is associated with the apikey,
##' otherwise FALSE.  Throws a warning if the device is valid,
##' is inactive.
##'
##' @noRd
.isValidDevice <- function(device, apikey){
    devs <- pbGetDevices(apikey)
    idx <- which(devs$devices$iden==device)
    if(length(idx)>0){
        if(!all(devs$devices$active[idx]))
            warning("The device with ID ",device,
                    " is associated with this account,",
                    "but it is not active.")
        return(TRUE)
    }
    return(FALSE)					#nocov
}

##' Test if channel is valid
##'
##' @param channel a string representing a Pushbullet channel
##'
##' @return TRUE if this is a valid channel, otherwise FALSE
##'
##' @noRd
##' @examples
##' ## TRUE
##' RPushbullet:::.isValidChannel("xkcd")
##'
##' ## FALSE, (probably)
##' RPushbullet:::.isValidChannel(as.character(runif(1)))
.isValidChannel <- function(channel){
    pbUrl <- paste0("https://api.pushbullet.com/v2/channel-info?tag=",
                    curl::curl_escape(channel),"&no_recent_pushes=true")
    jsonres <- curl::curl_fetch_memory(pbUrl)
    return(jsonres$status_code==200)
}
