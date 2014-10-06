
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
    str(fromJSON(pbGetDevices()))

    ## Post a note item
    str(fromJSON(pbPost("note", "simple Test", "We think this should work.\nWe really do.")))
}
