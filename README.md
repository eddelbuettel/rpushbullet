## RPushbullet [![Build Status](https://travis-ci.org/eddelbuettel/rpushbullet.svg)](https://travis-ci.org/eddelbuettel/rpushbullet) [![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN](http://www.r-pkg.org/badges/version/RPushbullet)](https://cran.r-project.org/package=RPushbullet) [![Downloads](http://cranlogs.r-pkg.org/badges/RPushbullet?color=brightgreen)](http://www.r-pkg.org/pkg/RPushbullet) [![Code Coverage](https://codecov.io/gh/eddelbuettel/rpushbullet/graph/badge.svg)](https://codecov.io/gh/eddelbuettel/rpushbullet)

### R interface to Pushbullet

[Pushbullet](http://www.pushbullet.com) is an awesome (and still free
for a very useful set of features with additional premium service for
extras) service to pass messages between your computer(s), phone(s) and
tablet(s).  It offers immediacy which is perfect for alerting, and
much more.

To use it, first register to obtain an API key from the 
[Pushbullet](https://www.pushbullet.com) site, and maybe install
the Android or iPhone app, or one of the supported browser extension or
desktop applications.  See the [Pushbullet](https://www.pushbullet.com)
documentation for more information and details.

### Example 

With a resource file (see below) properly setup, you can just do something like the following

```r
R> msg   # just an example, can be driven by real simulation results  
[1] "DONE after 10000 simulations taking 42.43 minutes reducing RMSE by  7.89 percent"  
R>  
R> RPushbullet::pbPost("note", title="Simulation complete", body=msg)  
R> pbPost("note", title="Simulation complete", body=msg)  
R>  
```

and a message like the image following below should pop up (if messaging directed to the browser):

![](https://github.com/eddelbuettel/rpushbullet/raw/master/attic/rpushbullet_message.png)  

Another excellent use case was suggested years ago by [Karl Broman](http://kbroman.org/) in 
[this blog post](https://kbroman.wordpress.com/2014/09/04/error-notifications-from-r/). We can 
improve on his version a little as one no longer needs to load the package:

```r
options(error = function() { 
    RPushbullet::pbPost("note", "Error", geterrmessage())
    if(!interactive()) stop(geterrmessage())
})
```

There was one noteworthy follow-up for which I lost the source: it suggested to make the message 
somewhat saltier by relying on the helpful [rfoaas](http://dirk.eddelbuettel.com/code/rfoaas.html) package.

### Package Status

The package is reasonably mature and functional. 

Up until release 0.2.0, an external `curl` binary was used. We have since switched to using
the [curl](https://cran.r-project.org/package=curl) package.

Given that the [Pushbullet API](https://docs.pushbullet.com/) has other nice features, future 
extensions are certainly possible and encouragement.  Interested contributors should file issue 
tickets first to discuss before going off on pull requests.

### Initialization

A file `~/.rpushbullet.json` can be used to pass the API key and device
identifiers to the package.  The content is read upon package startup, and
stored in a package-local environment. The format of this file is as follows:
```
{ 
    "key": "...placey your api key here...",

    "devices": [ 
        ".....device 1 id......",
        ".....device 2 id......",
        ".....device 3 id......"
    ],

    "names": [
        "...name1...",
        "...name2...",
        "...name3..."
    ],

    "defaultdevice": "...nameOfYourDefault..."
}
```

The `names` and `defaultdevice` fields are optional. See the main package
help page for more details.

You can also create the file programmatically via

```r
cat(jsonlite::toJSON(list(key="..key here..", devices=c("..aa..", "..bb.."))))
```

and write that content to the file `~/.rpushbullet.json`.

Starting with release 0.3.0, a new helper function `pbSetup()` is also
available to create the file.

You can also retrieve the ids of your devices with the `pbGetDevices()`
function by calling, say, `str(fromJSON(pbGetDevices()))`.  Note that you
need to load one of the packages `RJSONIO` or `rjson` or `jsonlite` to access
the `fromJSON()` function.

### Channels

Pushbullet has recently added [channels](https://www.pushbullet.com/channels)
to their API. These are notification feeds that user can subscribe to, and
which allows the developer to create (per-topic) channels for various
applications / topics that her users can subscribe to.

Creating a channel is easy: one simply needs to login and visit the
[My Channel](https://www.pushbullet.com/my-channel) page. From there, one
can easily create a new channel by clicking the "add channel" button. There
will be a prompt to enter a 'tag', a channel name, as well as a
description. The `channel_tag` is what is needed to push posts to the
channel. Currently, only the owner of a channel has permissions to post to
that channel, so one will need to create the channel using the same login one
has specified in `~/.rpushbullet.json` in order to use RPushbullet to post to
a channel.

_Channels are public_: Anyone who knows the channel 'tag' can subscribe and
will therefore receive all messages pushed to that channel. Some users create
hard-to-guess channel tags to achieve semi privacy. This works because it is,
currently as of February 2015, neither possible to list the channels owned by
a specific user nor possible to browse or search for other users' channels.
One method to generate a hard-to-guess tag is `digest::digest(rnorm(1))`.

Channels can be used by passing a `channel` argument to the `pbPost`
function. The Pushbullet API identifies a channel via the
supplied `channel_tag` value of this argument. See the
[Pushes API documentation](https://docs.pushbullet.com/v2/pushes/) for more
information.


### Author

Dirk Eddelbuettel with contributions by Bill Evans, Mike Birdgeneau, Henrik Bengtsson, and Seth Wenchel

### License

GPL (>= 2)

