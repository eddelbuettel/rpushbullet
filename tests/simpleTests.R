
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

    ## Post a note item
    str(fromJSON(pbPost("note", "A Simple Test", "We think this should work.\nWe really do.")[[1]]))

    ## Post an address -- should open browser in Google Maps
    str(fromJSON(pbPost(type="address", title="An Address", body="South Pole, Antarctica")[[1]]))

    ## Post a URL -- should open browser
    str(fromJSON(pbPost(type="link", title="Some title", body="Some URL",
                        url="http://cran.r-project.org/package=RPushbullet")[[1]]))

    #### Posting Files with different arguments ####

    ## Post a file with no recipients
    str(fromJSON(pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"))[[1]]))

    ## Post a file with numeric recipient
    str(fromJSON(pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"),
                        recipients = 1)[[1]]))

    ## Post a file with device name of recipient specified
    str(fromJSON(pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"),
                        recipients = "iPhone")[[1]]))

    ## Post a file with an email recipient specified:
    str(fromJSON(pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"),
                        email = "youremail@yourdomain.com")[[1]]))

}
