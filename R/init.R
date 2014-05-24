
.pkgglobalenv <- new.env(parent=emptyenv())

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet version ",
                          packageDescription("RPushbullet")$Version, ".")

    dotfile <- "~/.rpushbullet.json"
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        pb <- fromJSON(dotfile)
        assign("pb", pb, envir=.pkgglobalenv)
    } else {
        txt <- paste("No file", dotfile, "found.\nConsider placing the",
                     "Pushbullet API key and your device id(s) there.")
        packageStartupMessage(txt)
        assign("pb", NULL, envir=.pkgglobalenv)
    }
}
