
if (Sys.getenv("Run_RPushbullet_Tests")=="yes") {
    ## These simple tests rely on the existence of a config file with key and device info
    ## Otherwise we would have to hardcode a key and/or device id, and that is not something
    ## one should store in a code repository.
    ##
    ## I put a request in to the authors of Pushbullet to provide a "test id" key, and they
    ## are sympathetetic but do not have one implemented yet, and only suggested a woraround
    # of a 'throwaway' GMail id which I find unappealing.
    stopifnot(file.exists("~/.rpushbullet.json"))

    library(RPushbullet)

    ## As there is a file, check the package global environment 'pb' we create on startup
    RPushbullet:::.pkgenv[["pb"]]
    RPushbullet:::.pkgenv[["pb"]][["key"]]
    RPushbullet:::.pkgenv[["pb"]][["devices"]]

    ## As well as the options we create then too
    getOption("rpushbullet.key")
    getOption("rpushbullet.devices")

    ## Check the internal helper functions
    RPushbullet:::.getKey()
    RPushbullet:::.getDevices()

    ## Show the list of devices registered to the key
    require(RJSONIO)
    str(pbGetDevices())

    ## Test destinations
    devices <- unlist(RPushbullet:::.getNames())
    email <- RPushbullet:::.getTestEmail()  ## or res$receiver_email?!?
    channel <- RPushbullet:::.getTestChannel()

    hasEmail <- (length(email) > 0L)
    hasDevices <- (length(devices) > 0L)
    hasChannel <- (length(channel) > 0L)

    ## Function to add incremental counts to titles
    count <- local({
        counter <- 0L
        function(msg=NULL) {
            if (identical(msg, FALSE)) return(counter)
            counter <<- counter + 1L
            if (identical(msg, TRUE)) return(counter)
            sprintf("%02d. %s", counter, msg)
        }
    })

    ## Function to create incremental counted dummy files
    testfile <- function(count=1L) {
        filename <- sprintf("test_file_for_post_%02d.txt", count)
        pathname <- file.path(tempdir(), filename)
        cat(filename, file=pathname)
        pathname
    }

    ## Post a note item
    title <- "A Simple Test"
    body <- "We think this should work.\nWe really do."
    res <- fromJSON(pbPost("note", count(title),
                           "We think this should work.\nWe really do.")[[1]])
    str(res)
    ## storing this test result to allow us to use active user's email for testing below.


    ## Post an address -- should open browser in Google Maps
    str(fromJSON(pbPost(type="address", title=count("An Address"),
                        body="South Pole, Antarctica")[[1]]))

    ## Post a URL -- should open browser
    str(fromJSON(pbPost(type="link", title=count("Some title"), body="Some URL",
                        url="http://cran.r-project.org/package=RPushbullet")[[1]]))

    #### Posting Files with different arguments ####

    ## Post a file with no recipients
    file <- testfile(count(TRUE))
    str(fromJSON(pbPost(type="file", url=file)[[1]]))

    ## Post a file with numeric recipient
    if (hasDevices) {
        file <- testfile(count(TRUE))
        str(fromJSON(pbPost(type="file", url=file, recipients = 1)[[1]]))

        ## Post a file with device name of recipient specified
        file <- testfile(count(TRUE))
        str(fromJSON(pbPost(type="file", url=file, recipients = devices)[[1]]))

        ## Post a file with an email recipient specified:
        file <- testfile(count(TRUE))
        str(fromJSON(pbPost(type="file", url=file,
                           email = res$receiver_email)[[1]]))

        ## Post file with both email and numeric recipient specified:
        file <- testfile(count(TRUE))
        str(fromJSON(pbPost(type="file", url=file,
                           recipients = devices[1],
                           email = res$receiver_email)[[1]]))
   } # if (hasDevices)


    if (hasChannel && hasDevices && hasEmail) {
        ## Test hierarchy of arguments with channel specified:
        ## 1) All three should send to recipients.
        ## 2) Email and channel should send to email.
        ## 3) Recipients and channel should send to recipients
        ## 4) Only channel should send to channel.

        ## Post a note with recipients, email and channel specified.
        result <- fromJSON(pbPost(type="note", title=count(title), body=body,
                                  recipients = devices[1],
                                  email = email,
                                  channel = channel)[[1]])
        if (is.null(result$target_device_iden)) {
            stop("Test Failed.")
        }

        ## Post a note with email and channel specified.
        result <- fromJSON(pbPost(type="note", title=count(title), body=body,
                                  email = email,
                                  channel = channel)[[1]])
        if (is.null(result$receiver_email)) {
            stop("Test Failed.")
        }

        ## Post a note with recipients and channel specified.
        result <- fromJSON(pbPost(type="note", title=count(title), body=body,
                                  recipients = devices[1],
                                  channel = channel)[[1]])
        if (is.null(result$target_device_iden)) {
            stop("Test Failed.")
        }

        ## Post a note with only the channel specified.
        str(fromJSON(pbPost(type="note", title=count(title), body=body,
                            channel = channel,
                            verbose=TRUE)[[1]]))
        # Returns empty list, but posts successfully. API seems to return empty JSON. (tested curl command)
    } # if (hasChannel && hasDevices && hasEmail)


    ## Post closing note
    title <- count(sprintf("Test of RPushbullet %s completed", packageVersion("RPushbullet")))
    body <- sprintf("In total %d posts were made including this one", count(FALSE))
    res <- fromJSON(pbPost("note", title, body)[[1]])
    str(res)


}
