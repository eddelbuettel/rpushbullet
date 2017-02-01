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

##' Create a JSON config file
##'
##' @param apikey An \emph{Access Token} provided by Pushbullet (see details). If not
##' provided in the function call, the user will be prompted to enter one.
##' @param conffile A string giving the path where the configuration file will
##' be written. RPushbullet will automatically attempt load from the default location
##' \code{~/.rpushbullet.json} (which can be changed via a \code{rpushbullet.dotfile})
##' entry in \code{options}).
##' @return \code{NULL} is returned invisibly, but the function is called for its side
##' effect of creating the configuration file.
##' @details This function writes a simple default configuration file based
##' on a given apikey.  It is intended to be run once to help new users setup
##' RPushbullet. Running multiple times without overriding the
##' \code{config_file} parameter will overwrite the default file. An \emph{Access
##' Token} may be obtained for free by logging into the Pushbullet website,
##' going to \url{https://www.pushbullet.com/#settings}, and clicking on
##' "Create Access Token".
##' @examples
##' \dontrun{
##' # Interactive mode.  Just follow the prompts.
##' pbSetup()
##' }
##' @author Seth Wenchel and Dirk Eddelbuettel
pbSetup <- function(apikey, conffile) {

    if (missing(apikey)) apikey <- readline("Please enter your API key (aka 'Access Token': ")
    if (missing(conffile)) conffile <- .getDotfile()

    pdgd <- pbGetDevices(apikey)

    if (!length(pdgd$devices)) stop("no devices found for ", apikey, call.=FALSE)

    devices <- names <- rep(NA_character_, nrow(pdgd$devices)) # default to NA
    ind <- with(pdgd$devices, active & pushable)
    devices[ind] <- pdgd$devices[ind, "iden"]
    names[ind]   <- pdgd$devices[ind, "nickname"]

    devices <- na.omit(devices)
    names <- na.omit(names)

    for (i in seq_along(names)) {
        print(paste0(i,". ",names[i]))
    }
    defdev <- readline("Select a default device (0 for none): ")

    reslist <- list(key=apikey, devices = devices, names = names)
    if (defdev %in% as.character(seq_along(names)))
        reslist$defaultdevice <- names[as.integer(defdev)]

    json <- toJSON(reslist, auto_unbox = TRUE)

    f <- file(conffile,open = "w")
    cat(json,file = f)
    close(f)
    invisible(NULL)
}
