\name{RPushbullet-package}
\alias{RPushbullet-package}
\alias{RPushbullet}
\docType{package}
\title{
  R interface to the Pushbullet service
}
\description{
  The \href{http://www.pushbullet.com}{Pushbullet} service
  permits users to pass messenges between their computers, phones and
  other devices such as tablets.  It offers immediacy
  which is perfect for alerting, and much more.

  This package provides a programmatic interface from R.
}
\details{
  The \href{https://www.pushbullet.com/api}{Pushbullet API} offers a
  RESTful interface which requires an API key. A key can be obtained free
  of charge from \href{https://www.pushbullet.com}{Pushbullet}.  Given
  such a key, and one or more registered devices, 
  users can push messages to one or more device, or a given email
  address.

  The main function is \code{\link{pbPost}} which can be used to send a
  message comprising a note (with free-form body and title), link (for
  sending a URL), or even a file. The message recipients is
  typically one (or several) of the devices known to the user (see the
  next section for details), it can also be an email address in which
  case \href{http://www.pushbullet.com}{Pushbullet} creates and sends an
  email to the given address.
}
\section{Initialization}{
  The authentication key, as well as the device id, nicknames for the
  devices and default device can all be declared in several ways.

  One possibility is to use a file \code{.rpushbullet.json} in the
  \code{$HOME} directory. (Note that on Windows you may have to set the
  \code{$HOME} environment variable.) It uses the JSON format which uses
  a key:value pair notation; values may be arrays.  A simple example
  follows.

  \preformatted{
{ 
    "key": "abc...YourKeyHereBetweenQuote....xyz",

    "devices": [ 
        "abc...SomeId.......xyz",
        "abc...SomeOtherId..xyz"
    ],

    "names": [
        "Phone",
        "Browser"
    ],

    "defaultdevice": "Phone"
}
}
  The entire block is delimited by a pair of curly braces. Within the
  curly braces we have \dQuote{key} and \dQuote{devices} which are
  mandatory. Here \dQuote{key} is expected to contain a single value;
  \dQuote{devices} can be an array which is denoted by square brackets.
  Optionally a \dQuote{names} single value or array can be used to
  assign nicknames to the devices. Lastly, a \dQuote{defaultdevice} can
  be designated as well.

  However, use of a configuration file is not mandatory. The arguments
  can also be supplied as global options (which could be done in the
  usual R startup files, see \code{\link{Startup}} for details) as well
  as via standard function arguments when calling the corresponding
  functions. When using global options, use the names
  \code{rpushbullet.key}, \code{rpushbullet.devices}, \code{rpushbullet.names}, 
  and \code{rpushbullet.defaultdevice} corresponding to the entries in
  the JSON file shown above.

  The \code{curl} binary is required, and is located at package
  initialization, along with the other load-time intializations
  described here.  It is therefore strongly recommended to attach the
  package in the normal way via \code{library(RPushbullet)} rather than
  trying to access functions from the package namespace.
}
\author{
  Dirk Eddelbuettel 
}
\seealso{
  The documentation for the main function \code{\link{pbPost}}, as well
  as the documentation for \code{\link{pbGetDevices}}.
}
\references{
  See the Pushbullet documentation at the
  \href{http://www.pushbullet.com}{Pushbullet website}.
}
\keyword{package}
