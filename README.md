## RPushbullet: R interface to Pushbullet

[![Build Status](https://travis-ci.org/eddelbuettel/rpushbullet.png)](https://travis-ci.org/eddelbuettel/rpushbullet)

[Pushbullet](http://www.pushbullet.com) is an awesome (and free) service to
pass messenges between your computer, phone and tablet.  It offers immediacy
which is perfect for alerting, and much more.

To use it, just register as a user to obtain an API key, and maybe install
the Android or iPhone app.  See the [Pushbullet](http://www.pushbullet.com)
documentation for more.

### Status

The package is functional, yet still somewhat experimental and subject to change.

Initial explorations at the end of March 2014 were not entirely successful:
Using [RCurl](http://cran.rstudio.com/package=RCurl), one could retrieve
decice lists, and push notes but would never retrieve the proper JSON response
from Pushbullet. I consulted with some of the RCurl experts (shoutout to Jeff
G, Hadley W, and Duncan TL) but without resolution.

So this is a simpler reboot. We simply call the `curl` binary, and retrieve
the JSON response.

### Initialization

A  file `~/.rpushbutton.json` can be used to pass the API key and device
identifiers to the package.  The content is read upon package startup, and
stored in a package-local environment.

### Author

Dirk Eddelbuettel

### License

GPL (>= 2)

