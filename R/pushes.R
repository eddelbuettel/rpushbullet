
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


##' This function posts a message to Pushbullet. Different types of
##' messages are supported: \sQuote{note}, \sQuote{link} or
##' \sQuote{address}.
##'
##' This function invokes the \sQuote{pushes} functionality of
##' the Pushbullet API; see \url{https://docs.pushbullet.com/v2/pushes} for more
##' details.
##'
##' When a \sQuote{note} is pushed, the recipient receives the
##' title and body of the note.  If a \sQuote{link} is pushed, the recipient's web
##' browser is opened at the given URL.  If an \sQuote{address} is
##' pushed, the recipient's web browser is opened in map mode at the
##' given address.
##'
##' The \sQuote{deviceind} can be NULL to use the default device as
##' defined as \sQuote{defdevice} in \code{~/.rpushbullet.json}; a
##' positive integer to indicate the device to which the message will
##' be sent; a vector or list of such indices; or 0 to send to all
##' devices listed in the pushbullet account.
##' 
##' Note: when choosing 0 for the \sQuote{deviceind}, the message is
##' sent to all devices in the pushbullet account, regardless of the
##' \sQuote{devices} vector or those defined in
##' \code{~/.rpushbullet.json}. If you want to send to only those
##' defined in \sQuote{devices} excluding extras in your pushbullet
##' account, provide a vector or list of device indices in
##' \sQuote{deviceind}.
##' @title Post a message via Pushbullet
##' @param type The type of post: one of \sQuote{note}, sQuote{link}
##' or \sQuote{address}.
##' @param title The title of the note, or the name of the address, being posted.
##' @param body The body of the note, or the address when \code{type} is \sQuote{address}, or the (optional) body when the \code{type} is \sQuote{link}.
##' @param url The URL of \code{type} is \sQuote{link}.
##' @param deviceind The index (or a vector/list of indices) of the
##' device(s) in the list of devices. See 'Details'.
##' @param apikey The API key used to access the service. It can be
##' supplied as an argument here, via the global option
##' \code{rpushbullet.key}, or via the file \code{~/.rpushbullet.json}
##' which is read at package initialization (and, if found, also sets
##' the global option).
##' @param devices The device to which this post is pushed. It can be
##' supplied as an argument here, or via the file
##' \code{~/.rpushbullet.json} which is read at package
##' initialization.
##' @param verbose Boolean switch to add additional output
##' @return A JSON result record is return invisibly
##' @author Dirk Eddelbuettel
pbPost <- function(type=c("note", "link", "address"), #"list", "file"),
                   title="",            # also name for type='address'
                   body="",             # also address for type='address',
                                        # and items for type='list'
                   url="",
                   deviceind=NULL,
                   apikey = .getKey(),
                   devices = .getDevices(),
                   verbose = FALSE) {

    type <- match.arg(type)
    pburl <- "https://api.pushbullet.com/v2/pushes"
    curl <- .getCurl()
    
    if (is.null(deviceind))
        deviceind <- .getDefDevice()

    if (0 %in% deviceind) {
        ## this will send to all devices in the pushbullet account,
        ## explicitly including others would result in double-tapping
        deviceind <- 0
    }

    ret <- sapply(deviceind, function(ind) {
        tgt <- ifelse(ind == 0,
                      '',                             # all devices
                      sprintf('-d device_iden="%s" ', # specific device
                              devices[ind]))

        txt <- switch(type,

                      ## curl https://api.pushbullet.com/v2/pushes \
                      ##   -u <your_api_key_here>: \
                      ##   -d device_iden="<your_device_iden_here>" \
                      ##   -d type="note" \
                      ##   -d title="Note title" \
                      ##   -d body="note body" \
                      ##   -X POST
                      note = sprintf(paste0('%s -s %s -u %s: %s ',
                          '-d type="note" -d title="%s" -d body="%s" -X POST'),
                          curl, pburl, apikey, tgt, title, body),

                      link = sprintf(paste0('%s -s %s -u %s: %s ',
                          '-d type="link" -d title="%s" -d body="%s" ',
                          '-d url="%s" -X POST'),
                          curl, pburl, apikey, tgt, title, body, url),

                      address = sprintf(paste0('%s -s %s -u %s: %s ',
                          '-d type="address" -d name="%s" -d address="%s" ',
                          '-X POST'),
                          curl, apikey, tgt, title, body)

                      ## ## not quite sure what a list body would be
                      ## list = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                      ##                       '-d type="list" -d title="%s" -d items="%s" -X POST'),
                      ##                pburl, apikey, device, title, body),

                      ## for file see docs, need to upload file first
                      ## file = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                      ##                       '-d type="link" -d title="%s" -d body="%s" ',
                      ##                       '-d url="%s" -X POST'),
                      ##                pburl, apikey, device, title, body, url),

                      )

        if (verbose) print(txt)
        system(txt, intern=TRUE)
    })
    invisible(ret)
}
