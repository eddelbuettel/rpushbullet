
##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2014         Dirk Eddelbuettel <edd@debian.org>
##  Copyright (C) 2014 - 2015  Dirk Eddelbuettel and Mike Birdgeneau
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
##' messages are supported: \sQuote{note}, \sQuote{link},
##' \sQuote{address}, or \sQuote{file}.
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
##' If \sQuote{recipients} argument is missing, the post is pushed to
##' \emph{all} devices in accordance with the API definition. If
##' \sQuote{recipients} is text vector, it matched against the device
##' names (from either the config file or a corresponding
##' option). Lastly, if \sQuote{recipients} is a numeric vector, the
##' post is pushed the corresponding elements in the devices vector.
##'
##' In other words, the default of value of no specified recipients results
##' in sending to all devices. If you want a particular subset of
##' devices you have to specify it name or index. A default device can be set
##' in the configuration file, or as a global option. If none is set, zero
##' is used as a code to imply \sQuote{all} devices.
##'
##' The earlier argument \code{deviceind} is now deprecated and will
##' be removed in a later release.
##' @title Post a message via Pushbullet
##' @param type The type of post: one of \sQuote{note}, \sQuote{link}, \sQuote{file}
##' or \sQuote{address}.
##' @param title The title of the note, or the name of the address, being posted.
##' @param body The body of the note, or the address when \code{type}
##' is \sQuote{address}, or the (optional) body when the \code{type}
##' is \sQuote{link}.
##' @param url The URL of \code{type} is \sQuote{link}, or the local
##' path of a file to be sent if \code{type} is \sQuote{file}.
##' @param filetype The MIME type for the file at \code{url} (if
##' \code{type} is \sQuote{file}), defaults to \dQuote{text/plain}.
##' @param recipients A character or numeric vector indicating the
##' devices this post should go to. If missing, the default device
##' is looked up from an optional setting, and if none has been set
##' the push is sent to all devices.
##' @param email An alternative way to specify a recipient is to specify
##' an email address. If both \code{recipients} and \code{email} are
##' present, \code{recipients} is used.
##' @param channel A channel tag used to specify the name of the channel
##' as the recipient. If either \code{recipients} or \code{email} are present,
##' they will take precedence over \code{channel}.
##' @param deviceind (Deprecated) The index (or a vector/list of indices) of the
##' device(s) in the list of devices.
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
##' @param debug Boolean switch to add even more debugging output
##' @return A JSON result record is return invisibly
##' @author Dirk Eddelbuettel
##' @examples
##' \dontrun{
##' # A note
##' pbPost("note", "A Simple Test", "We think this should work.\nWe really do.")
##'
##' # An address -- should open browser in Google Maps
##' pbPost(type="address", title="An Address", body="South Pole, Antarctica")
##'
##' # A URL -- should open browser
##' pbPost(type="link", title="Some title", body="Some URL",
##'        url="http://cran.r-project.org/package=RPushbullet")
##'
##' # A file
##' pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"))
##' }
pbPost <- function(type=c("note", "link", "address", "file"),
                   title="",             # also name for type='address'
                   body="",              # also address for type='address',
                                         # and items for type='list'
                   url="",               # url if post is of type link, or
                                         # local path to file for type='file'
                   filetype="text/plain",# file type for upload of type='file'
                   recipients,           # devices to post to
                   email,                # alternatively use an email
                   channel,              # alternatively specify a channel
                   deviceind,            # deprecated, see detail
                   apikey = .getKey(),
                   devices = .getDevices(),
                   verbose = FALSE,
                   debug = FALSE) {

    type <- match.arg(type)

    if (!missing(deviceind)) {
        if (missing(recipients) && missing(email) && missing(channel)) {
            warning("Agument 'deviceind' is deprecated. Please use 'recipients'.", call.=FALSE)
            recipients <- deviceind
        } else {
            warning("Using 'recipients' (or 'email' or 'channel') and ignoring deprecated 'deviceinds'.",
                    call.=FALSE)
        }
    }

    if (missing(recipients) && missing(email) && missing(channel)) {
        if (debug) message("missing recipient and email and channel")
        recipients <- .getDefaultDevice() # either supplied, or 0 as fallback
        if (recipients==0) {
            dest <- ''
        } else {
            dest <- match(recipients, .getNames())
        }
        email <- channel <- NA
    } else {
        if (!missing(recipients)) {     # hence recipient present
            if (is.character(recipients)) {
                dest <- match(recipients, .getNames())
            } else {
                dest <- recipients      # numeric values
            }
            email <- NA
        } else {                        # either email or channel present
            if(!missing(email)) {
                dest <- email
            } else {                    # hence channel present
                dest <- channel
                email <- NA # Set e-mail to NA, missing() is unreliable
            }
       }
    }

    pburl <- "https://api.pushbullet.com/v2/pushes"
    curl <- .getCurl()

    ## if (is.null(deviceind))
    ##     deviceind <- .getDefaultDevice()

    ## if (0 %in% deviceind) {
    ##     ## this will send to all devices in the pushbullet account,
    ##     ## explicitly including others would result in double-tapping
    ##     deviceind <- 0
    ## }

    if (type=="file") {
        if (url != "" && filetype != "") {             # Request Upload
            url <- normalizePath(url)                  # abs/rel path, tilde expansion, ...
            uploadrequest <- .getUploadRequest(filename = url, filetype = filetype)
            #fileurl <- uploadrequest$file_url

            # Upload File
            txt <- sprintf(paste0("%s -s -i %s -F awsaccesskeyid='%s' -F acl='%s' ",
                                  "-F key='%s' -F signature='%s' -F policy='%s' ",
                                  "-F content-type='%s' -F 'file=@%s'"),
                           curl,
                           uploadrequest$upload_url,
                           uploadrequest$data['awsaccesskeyid'],
                           uploadrequest$data['acl'],
                           uploadrequest$data['key'],
                           uploadrequest$data['signature'],
                           uploadrequest$data['policy'],
                           uploadrequest$data['content-type'],
                           url)
            uploadresult <- system(txt, intern=TRUE)
        }
    }

    ret <- lapply(dest, function(d) {
        if (debug) message(sprintf("in lapply, d is: %s", d))   
        if (is.character(d)) {          # this is an email or channel.
            if (!is.na(email)){
                tgt <- sprintf(' -d email="%s" ', d)
            } else {                    # hence assume channel
                tgt <- sprintf(' -d channel_tag="%s" ', d)
            }
        } else if (is.numeric(d)) {     # this a listed device, now transfered to index
            tgt <- ifelse(d == 0,       # if zero, then use all devices
                          '',           # otherwise given specific device
                          sprintf('-d device_iden="%s" ', devices[d]))
        } else {                        # fallback, should not get reached
            tgt <- ''
        }

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
                          curl, pburl, apikey, tgt, title, body),

                      ## ## not quite sure what a list body would be
                      ## list = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                      ##                       '-d type="list" -d title="%s" -d items="%s" ',
                      ##                       '-X POST'),
                      ##                pburl, apikey, device, title, body),

                      ## for file see docs, need to upload file first
                      file = sprintf(paste0('%s -s %s -u %s: %s ',
                                            '-d type="file" -d file_name="%s" ',
                                            '-d file_type="%s" ',
                                            '-d file_url="%s" ',
                                            '-d body="%s" -X POST'),
                                     curl, pburl, apikey, tgt,
                                     basename(uploadrequest$file_name),
                                     uploadrequest$file_type, uploadrequest$file_url, body)
                      )
        if (verbose) print(txt)
        system(txt, intern=TRUE)
    })
    invisible(ret)
}
