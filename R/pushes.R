
##  RPushbullet -- R interface to Pushbullet libraries
##
##  Copyright (C) 2014         Dirk Eddelbuettel <edd@debian.org>
##  Copyright (C) 2014 - 2016  Dirk Eddelbuettel and Mike Birdgeneau
##  Copyright (C) 2014 - 2019  Dirk Eddelbuettel, Mike Birdgeneau and Seth Wenchel
##  Copyright (C) 2019 - 2021  Dirk Eddelbuettel, Mike Birdgeneau, Seth Wenchel
##                             and Chan-Yub Park
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
##' the Pushbullet API; see \url{https://docs.pushbullet.com/} for more
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
##'
##' In some cases servers may prefer the older \sQuote{HTTP 1.1}
##' standard (as opposed to the newer \sQuote{HTTP 2.0} set by
##' \code{curl}). Setting the option \dQuote{rpushbullet.useHTTP11} to
##' \code{TRUE} will enable use of \sQuote{HTTP 1.1}.
##'
##' @title Post a message via Pushbullet
##' @param type The type of post: one of \sQuote{note}, \sQuote{link}, or \sQuote{file}.
##' @param title The title of the note being posted.
##' @param body The body of the note or the (optional) body when the \code{type}
##' is \sQuote{link}.
##' @param url The URL of \code{type} is \sQuote{link}, or the local
##' path of a file to be sent if \code{type} is \sQuote{file}.
##' @param filetype The MIME type for the file at \code{url} (if
##' \code{type} is \sQuote{file}) such as \dQuote{text/plain} or \dQuote{image/jpeg},
##'  defaults to \dQuote{text/plain}.
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
##' # A URL -- should open browser
##' pbPost(type="link", title="Some title", body="Some URL",
##'        url="https://cran.r-project.org/package=RPushbullet")
##'
##' # A file
##' pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"))
##' }
pbPost <- function(type=c("note", "link", "file"),
                   title="",            # title of message
                   body="",             # also item items for type='list'
                   url="",              # url if post is of type link, or
                                        # local path to file for type='file'
                   filetype="text/plain", # file type for upload of type='file'
                   recipients,          # devices to post to
                   email,               # alternatively use an email
                   channel,             # alternatively specify a channel
                   deviceind,           # deprecated, see details
                   apikey = .getKey(),	# required API key with default provided
                   devices = .getDevices(),  # device(s) to post to, default providd
                   verbose = FALSE,	# verbose operations, default is quiet
                   debug = FALSE) {     # additional debugging output, default is quiet

    type <- match.arg(type)

    if (type == "address") {
        warning("Pushes of type 'address' are no longer supported by the Pushbullet ",	#nocov start
                "service. Attempt to push \'",body,"\' failed.")
        invisible(return(NA_character_))						#nocov end
    }


    if (!missing(deviceind)) {
        if (missing(recipients) && missing(email) && missing(channel)) {		#nocov start
            warning("Agument 'deviceind' is deprecated. Please use 'recipients'.", call.=FALSE)
            recipients <- deviceind
        } else {
            warning("Using 'recipients' (or 'email' or 'channel') and ",
                    "ignoring deprecated 'deviceinds'.", call.=FALSE)
        }										#nocov end
    }

    if (missing(recipients) && missing(email) && missing(channel)) {
        if (debug) message("missing recipient and email and channel")
        recipients <- .getDefaultDevice() # either supplied, or 0 as fallback
        if (recipients==0) {
            dest <- ''									#nocov
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
            if (!missing(email)) {
                dest <- email
            } else {                    # hence channel present
                dest <- channel								#nocov
                email <- NA 		# Set e-mail to NA, missing() is unreliable     #nocov
            }
       }
    }
    if (debug) cat("dest is: ", dest, "\n")

    pburl <- "https://api.pushbullet.com/v2/pushes"

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

            # Upload File
            h <- .getCurlHandle(apikey)
            form_list <- list(awsaccesskeyid=uploadrequest$data[['awsaccesskeyid']],
                              acl=uploadrequest$data[['acl']],
                              key=uploadrequest$data[['key']],
                              signature=uploadrequest$data[['signature']],
                              policy=uploadrequest$data[['policy']],
                              "content-type"=uploadrequest$data[['content-type']],
                              file=curl::form_file(url, filetype))

            curl::handle_setform(h, .list = form_list)
            uploadresult <- curl::curl_fetch_memory(uploadrequest$upload_url,h)
            if (uploadresult$status_code!=204) {
                warning("file upload attempt failed with status code: ",	#nocov start
                        uploadresult$status_code)
                return(rawToChar(uploadresult$content))				#nocov end
            }
        }
    }

    ret <- lapply(dest, function(d) {
        if (debug) message(sprintf("in lapply, d is: %s", d))
        if (is.character(d)) {          # this is an email or channel.
            if (!is.na(email[1])){      # TODO deal with NAs in positions other than first
                tgt <- list(email= d)
            } else {                    # hence assume channel
                tgt <- list(channel_tag= d)
            }
        } else if (is.numeric(d)) {     # this a listed device, now transfered to index
            if (d==0)
                tgt <- list() # if zero, then use all devices  			#nocov
            else
                tgt <- list(device_iden=devices[[d]]) # otherwise given specific device
         } else {                        # fallback, should not get reached
            tgt <- list()							#nocov
        }

        form_list <- tgt

        switch(type,

                      ## curl https://api.pushbullet.com/v2/pushes \
                      ##   -u <your_api_key_here>: \
                      ##   -d device_iden="<your_device_iden_here>" \
                      ##   -d type="note" \
                      ##   -d title="Note title" \
                      ##   -d body="note body" \
                      ##   -X POST
                      note = {
                          form_list[["type"]] <- "note";
                          form_list[["title"]] <- title;
                          form_list[["body"]] <- body;},

                      link = {
                          form_list[["type"]] <- "link";
                          form_list[["title"]] <- title;
                          form_list[["body"]] <- body;
                          form_list[["url"]] <- url;},

                      ## ## not quite sure what a list body would be
                      ## list = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                      ##                       '-d type="list" -d title="%s" -d items="%s" ',
                      ##                       '-X POST'),
                      ##                pburl, apikey, device, title, body),

                      ## for file see docs, need to upload file first
                      file = {
                          form_list[["type"]] <- "file";
                          form_list[["file_name"]] <- basename(uploadrequest$file_name);
                          form_list[["file_type"]] <- uploadrequest$file_type;
                          form_list[["file_url"]] <- uploadrequest$file_url;
                          form_list[["body"]] <- body;}
                      )
        if (verbose) print(form_list)
        .createPush(pburl, apikey, form_list)
    })
    invisible(ret)
}


##' This function gets messages posted to Pushbullet.
##'
##' @title Get messages posted via Pushbullet
##' @param apikey The API key used to access the service. It can be
##' supplied as an argument here, via the global option
##' \code{rpushbullet.key}, or via the file \code{~/.rpushbullet.json}
##' which is read at package initialization (and, if found, also sets
##' the global option).
##' \code{~/.rpushbullet.json} which is read at package
##' initialization.
##' @param limit Limit number of post. Default is 10.
##' @return A data.frame result record is returned
##' @author Chan-Yub Park
##' @examples
##' \dontrun{
##' pbGetPosts()
##' }
pbGetPosts <- function(apikey = .getKey(), limit = 10) {			#nocov start
    pburl <- paste0("https://api.pushbullet.com/v2/pushes?limit=", limit)
    res <- .createPush(pburl, apikey, hopt = "GET")
    Encoding(res) <- "UTF-8"
    jsonlite::fromJSON(res)$pushes
}										#nocov ends

.createPush <- function(pburl, apikey, form_list = NULL, hopt = "POST"){
    h <- .getCurlHandle(apikey)
    curl::handle_setopt(h, customrequest = hopt)
    if (!is.null(form_list)) {
        curl::handle_setform(h, .list = form_list)
    }
    res <- curl::curl_fetch_memory(pburl, handle = h)
    .checkReturnCode(res)
    return(rawToChar(res$content))
}
