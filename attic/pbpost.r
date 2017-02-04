#!/usr/bin/r

localPbPost <- function (type = c("note", "link", "file"),
                         title = "", body = "", url = "",
                         filetype = "text/plain",
                         recipients, email, channel, deviceind,
                         apikey = RPushbullet:::.getKey(),
                         devices = RPushbullet:::.getDevices(),
                         verbose = FALSE, debug = FALSE) {

    type <- match.arg(type)
    if (type == "address") {
        warning("Pushes of type 'address' are no longer supported by the Pushbullet ", 
                "service. Attempt to push '", body, "' failed.")
        invisible(return(NA_character_))
    }
    if (!missing(deviceind)) {
        if (missing(recipients) && missing(email) && missing(channel)) {
            warning("Agument 'deviceind' is deprecated. Please use 'recipients'.", call. = FALSE)
            recipients <- deviceind
        } else {
            warning("Using 'recipients' (or 'email' or 'channel') and ", 
                    "ignoring deprecated 'deviceinds'.", call. = FALSE)
        }
    }
    if (missing(recipients) && missing(email) && missing(channel)) {
        if (debug) message("missing recipient and email and channel")
        recipients <- RPushbullet:::.getDefaultDevice()
        if (recipients == 0) {
            dest <- ""
        }
        else {
            dest <- match(recipients, RPushbullet:::.getNames())
        }
        email <- channel <- NA
    }
    else {
        if (!missing(recipients)) {
            if (is.character(recipients)) {
                dest <- match(recipients, RPushbullet:::.getNames())
            }
            else {
                dest <- recipients
            }
            email <- NA
        }
        else {
            if (!missing(email)) {
                dest <- email
            }
            else {
                dest <- channel
                email <- NA
            }
        }
    }
    if (debug) cat("dest is: ", dest, "\n")

    pburl <- "https://api.pushbullet.com/v2/pushes"
    if (type == "file") {
        if (url != "" && filetype != "") {
            url <- normalizePath(url)
            uploadrequest <- RPushbullet:::.getUploadRequest(filename = url, 
                                                             filetype = filetype)
            h <- RPushbullet:::.getCurlHandle(apikey)
            form_list <- list(awsaccesskeyid = uploadrequest$data[["awsaccesskeyid"]], 
                              acl = uploadrequest$data[["acl"]], key = uploadrequest$data[["key"]], 
                              signature = uploadrequest$data[["signature"]], 
                              policy = uploadrequest$data[["policy"]],
                              `content-type` = uploadrequest$data[["content-type"]], 
                              file = curl::form_file(url, filetype))
            curl::handle_setform(h, .list = form_list)
            uploadresult <- curl::curl_fetch_memory(uploadrequest$upload_url, 
                                                    h)
            if (uploadresult$status_code != 204) {
                warning("file upload attempt failed with status code: ", 
                        uploadresult$status_code)
                return(rawToChar(uploadresult$content))
            }
        }
    }
    ret <- lapply(dest, function(d) {
        if (debug) 
            message(sprintf("in lapply, d is: %s", d))
        if (is.character(d)) {
            if (!is.na(email)) {
                tgt <- list(email = d)
            }
            else {
                tgt <- list(channel_tag = d)
            }
        }
        else if (is.numeric(d)) {
            if (d == 0) {
                tgt <- list()
            } else {
                if (debug) print(devices)
                tgt <- list(device_iden = devices[[d]])
            }
        }
        else {
            tgt <- list()
        }
        form_list <- tgt
        switch(type, note = {
            form_list[["type"]] <- "note"
            form_list[["title"]] <- title
            form_list[["body"]] <- body
        }, link = {
            form_list[["type"]] <- "link"
            form_list[["title"]] <- title
            form_list[["body"]] <- body
            form_list[["url"]] <- url
        }, file = {
            form_list[["type"]] <- "file"
            form_list[["file_name"]] <- basename(uploadrequest$file_name)
            form_list[["file_type"]] <- uploadrequest$file_type
            form_list[["file_url"]] <- uploadrequest$file_url
            form_list[["body"]] <- body
        })
        if (verbose) 
            print(form_list)
        RPushbullet:::.createPush(pburl, apikey, form_list)
    })
    invisible(ret)
}

