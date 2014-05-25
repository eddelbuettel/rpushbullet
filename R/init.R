
.pkgglobalenv <- new.env(parent=emptyenv())

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")

    dotfile <- "~/.rpushbullet.json"
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        pb <- fromJSON(dotfile)
        assign("pb", pb, envir=.pkgglobalenv)
        options("rpushbullet.key" = pb[["key"]])
        options("rpushbullet.devices" = pb[["devices"]])
    } else {
        txt <- paste("No file", dotfile, "found.\nConsider placing the",
                     "Pushbullet API key and your device id(s) there.")
        packageStartupMessage(txt)
        assign("pb", NULL, envir=.pkgglobalenv)
    }
}

.getKey <- function() {
    getOption("rpushbullet.key",        		# retrieve as option, 
              ifelse(!is.null(.pkgglobalenv$pb),        # else try environment
                     .pkgglobalenv$pb[["key"]],         # and use it, or signal error
                     stop(paste("Neither option 'rpushbutton.key' nor entry in",
                                "package environment found. Aborting."), call.=FALSE)))
}

.getDevices <- function() {
    getOption("rpushbullet.devices",        		# retrieve as option, 
              ifelse(!is.null(.pkgglobalenv$pb),	# else try environment
                     .pkgglobalenv$pb[["devices"]],     # and use it, or signal error
                     stop(paste("Neither option 'rpushbutton.devices' nor entry in",
                                "package environment found. Aborting."), call.=FALSE)))
}

