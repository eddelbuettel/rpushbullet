
.pkgglobalenv <- new.env(parent=emptyenv())

.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Attaching RPushbullet.")

    dotfile <- "~/.rpushbullet.json"
    if (file.exists(dotfile)) {
        packageStartupMessage("Reading ", dotfile)
        pb <- fromJSON(dotfile)
        assign("pb", pb, envir=.pkgglobalenv)
    } else {
        packageStartupMessage("No file ", dotfile,
                              "found. Consider placing Pushbullet API key there.")
        assign("pb", NULL, envir=.pkgglobalenv)
    }
}
