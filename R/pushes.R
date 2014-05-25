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
##' @title Post a message via Pushbullet
##' @param type The type of post: one of \sQuote{note}, sQuote{link}
##' or \sQuote{address}.
##' @param title The title of the note, or the name of the address, being posted.
##' @param body The body of the note, or the address when \code{type} is \sQuote{address}, or the (optional) body when the \code{type} is \sQuote{link}.
##' @param url The URL of \code{type} is \sQuote{link}.
##' @param deviceind The index of the device in the list of devices, defaults to one.
##' @param apikey The API key used to access the service. It can be
##' supplied as an argument here, via the global option
##' \code{rpushbutton.key}, or via the file \code{~/.rpushbullet.json}
##' which is read at package initialization (and, if found, also sets
##' the global option).
##' @param devices The device to which this post is pushed. It can be
##' supplied as an argument here, or via the file
##' \code{~/.rpushbullet.json} which is read at package
##' initialization.
##' @return A JSON result record is return invisibly
##' @author Dirk Eddelbuettel
pbPost <- function(type=c("note", "link", "address"), #"list", "file"),
                   title="",            # also name for type='address'
                   body="",             # also address for type='address',
                                        # and items for type='list'
                   url="",
                   deviceind=1,
                   apikey = .getKey(),
                   devices = .getDevices()) {

    type <- match.arg(type)

    txt <- switch(type,

                  ## curl https://api.pushbullet.com/v2/pushes \
                  ##   -u <your_api_key_here>: \
                  ##   -d device_iden="<your_device_iden_here>" \
                  ##   -d type="note" \
                  ##   -d title="Note title" \
                  ##   -d body="note body" \
                  ##   -X POST
                  note = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                                        '-d type="note" -d title="%s" -d body="%s" -X POST'),
                                 "https://api.pushbullet.com/v2/pushes", apikey, devices[deviceind],
                                 title, body),

                  link = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                                        '-d type="link" -d title="%s" -d body="%s" ',
                                        '-d url="%s" -X POST'),
                                 "https://api.pushbullet.com/v2/pushes", apikey, devices[deviceind],
                                 title, body, url),

                  address = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                                           '-d type="address" -d name="%s" -d address="%s" ',
                                           '-X POST'),
                                    "https://api.pushbullet.com/v2/pushes", apikey, devices[deviceind],
                                    title, body)

                  ## ## not quite sure what a list body would be
                  ## list = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                  ##                       '-d type="list" -d title="%s" -d items="%s" -X POST'),
                  ##                "https://api.pushbullet.com/v2/pushes", apikey, device,
                  ##                title, body),

                  ## for file see docs, need to upload file first
                  ## file = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                  ##                       '-d type="link" -d title="%s" -d body="%s" ',
                  ##                       '-d url="%s" -X POST'),
                  ##                "https://api.pushbullet.com/v2/pushes", apikey, device,
                  ##                title, body, url),

                  )

    print(txt)
    res <- system(txt, intern=TRUE)
    invisible(res)
}
