
#' Create a JSON config file
#'
#' @param apikey An \emph{Access Token} provided by Pushbullet (see details). If not
#'   provided in the function call, the user will be prompted to enter one.
#' @param config_file A string giving the path where the configuration file will
#'   be written. RPushbullet will automatically attempt load
#'   \code{~/.rpushbullet.json} (the default)
#'
#' @details This function writes a simple default configuration file based
#'   on a given apikey.  It is intended to be run once to help new users setup
#'   RPushbullet. Running multiple times without overriding the
#'   \code{config_file} parameter will overwrite the default file. An \emph{Access
#'   Token} may be obtained for free by logging into the Pushbullet website,
#'   going to \url{https://www.pushbullet.com/#settings}, and clicking on
#'   "Create Access Token".
#'
#' @export
#' @importFrom RJSONIO toJSON
#'
#' @examples
#' \dontrun{
#'
#' # Interactive mode.  Just follow the prompts.
#' pbSetup()
#' }
#' @author Seth Wenchel
pbSetup <- function(apikey=NULL, config_file="~/.rpushbullet.json"){
  if(is.null(apikey)){
    key <- readline("Please enter your API key (aka 'Access Token': ")
  }
  else
    key <- apikey
  pdgd <- pbGetDevices(key)
  devices <- vapply(pdgd$devices,function(x){ifelse(x[["active"]] && x[["pushable"]],x[["iden"]],NA_character_)},"")
  names <- vapply(pdgd$devices,function(x){ifelse(x[["active"]] && x[["pushable"]],x[["nickname"]],NA_character_)},"")

  devices <- devices[!is.na(devices)]
  names <- names[!is.na(names)]

  for (i in seq_along(names)){
    print(paste0(i,". ",names[i]))
  }
  def_dev <- readline("Select a default device (0 for none): ")

  the_list <- list(key=key, devices = devices, names = names)
  if(def_dev %in% as.character(seq_along(names)))
    the_list$defaultdevice <- names[as.integer(def_dev)]

  json <- RJSONIO::toJSON(the_list)

  f <- file(config_file,open = "w")
  cat(json,file = f)
  close(f)
}
