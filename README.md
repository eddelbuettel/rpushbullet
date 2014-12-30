## RPushbullet: R interface to Pushbullet

[![Build Status](https://travis-ci.org/eddelbuettel/rpushbullet.png)](https://travis-ci.org/eddelbuettel/rpushbullet)

[Pushbullet](http://www.pushbullet.com) is an awesome (and free) service to
pass messages between your computer, phone and tablet.  It offers immediacy
which is perfect for alerting, and much more.

To use it, just register as a user to obtain an API key, and maybe install
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
cat(RJSONSIO::toJSON(list(key="..key here..", devices=c("..aa..", "..bb.."))))
```

and write that content to the file `~/.rpushbullet.json`.

You can also retrieve the ids of your devices with the `pbGetDevices()`
function by calling, say, `str(fromJSON(pbGetDevices()))`.  Note that you
need to load one of the packages `RJSONIO` or `rjson` or `jsonlite` to access
the `fromJSON()` function.

### Channels

Pushbullet has recently implemented [channels](https://www.pushbullet.com/channels) into their API, which are notification feeds that can be subscribed to. This allows you to create channels for various applications / topics that users can subscribe to.

Creating a channel is very easy, you simply need to login and visit the [My Channels](https://www.pushbullet.com/my-channels) page. From there, you can easily create a new channel by clicking the "add channel" button. You will be prompted to enter a 'tag', a channel name, as well as a description. The channel 'tag' is what you will need to use to push posts to your channel. Currently, only the owner of a channel has permisisons to post to that channel, so you will need to create the channel using the same login you will have specified in `~/.rpushbullet.json` in order to use RPushbullet to post to a channel.

Channels are not currently implemented, but once complete the `pbPost` function will be modified to incorporate passing a `channel` argument to the Pushbullet pushes API as the target parameter: `channel_tag`. See the [Pushes API documentation](https://docs.pushbullet.com/v2/pushes/) for more information.


### Author

Dirk Eddelbuettel

### License

GPL (>= 2)

