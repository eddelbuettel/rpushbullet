## RPushbullet [![Build Status](https://travis-ci.org/eddelbuettel/rpushbullet.png)](https://travis-ci.org/eddelbuettel/rpushbullet) [![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

### R interface to Pushbullet

[Pushbullet](http://www.pushbullet.com) is an awesome (and free) service to
pass messages between your computer, phone and tablet.  It offers immediacy
which is perfect for alerting, and much more.

To use it, just register as a user to obtain an 
[API key](https://www.pushbullet.com/account), and maybe install
the Android or iPhone app.  See the [Pushbullet](http://www.pushbullet.com)
documentation for more, in particular

- [Getting Started](https://www.pushbullet.com/guide/getting-started)
- [Features](https://www.pushbullet.com/guide/getting-the-most-out-of-pushbullet)

### Package Status

The package is functional, yet still young and thus subject to change.

Initial explorations at the end of March 2014 were not entirely successful:
Using [RCurl](http://cran.rstudio.com/package=RCurl), one could retrieve
device lists, and push notes but would never retrieve the proper JSON response
from Pushbullet. I consulted with some of the RCurl experts (shoutout to Jeff
G, Hadley W, and Duncan TL) but without resolution.

So this is a simpler reboot. We simply call the `curl` binary, and retrieve
the JSON response.

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

```
cat(RJSONIO::toJSON(list(key="..key here..", devices=c("..aa..", "..bb.."))))
```

and write that content to the file `~/.rpushbullet.json`.

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
[Pushes API documentation](https://docs.pushbullet.com/v2/pushes/) for +more
information.


### Author

Dirk Eddelbuettel

### License

GPL (>= 2)

