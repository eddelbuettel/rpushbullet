
pbPost <- function(type=c("note", "link", "address"), #"list", "file"),
                   title="",            # also name for type='address'
                   body="",             # also address for type='address', and item for type='list'
                   url="",
                   deviceind=1,
                   apikey,
                   device) {

    type <- match.arg(type)
    
    if (missing(apikey)) {
        if (is.null(.pkgglobalenv$pb)) {
            stop("No 'apikey' argument provided, and no rc file found. Aborting.")
        }
        apikey <- .pkgglobalenv$pb["key"]
    }

    if (missing(device)) {
        if (is.null(.pkgglobalenv$pb)) {
            stop("No 'device' argument provided, and no rc file found. Aborting.")
        }
        device <- .pkgglobalenv$pb[["devices"]][deviceind]
    }


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
                                 "https://api.pushbullet.com/v2/pushes", apikey, device,
                                 title, body),

                  link = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                                        '-d type="link" -d title="%s" -d body="%s" ',
                                        '-d url="%s" -X POST'),
                                 "https://api.pushbullet.com/v2/pushes", apikey, device,
                                 title, body, url),

                  address = sprintf(paste0('curl -s %s -u %s: -d device_iden="%s" ',
                                           '-d type="address" -d name="%s" -d address="%s" ',
                                           '-X POST'),
                                    "https://api.pushbullet.com/v2/pushes", apikey, device,
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

    #print(txt)
    res <- system(txt, intern=TRUE)
    invisible(res)
}
