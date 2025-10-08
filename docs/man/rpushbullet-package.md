

# R interface to the Pushbullet service

## Description

The <a href="https://www.pushbullet.com">Pushbullet</a> service permits
users to pass messenges between their computers, phones and other
devices such as tablets. It offers immediacy which is perfect for
alerting, and much more.

This package provides a programmatic interface from R.

## Details

The <a href="https://www.pushbullet.com/api">Pushbullet API</a> offers a
RESTful interface which requires an API key. A key can be obtained free
of charge from <a href="https://www.pushbullet.com">Pushbullet</a>.
Given such a key, and one or more registered devices, users can push
messages to one or more device, or a given email address.

The main function is <code>pbPost</code> which can be used to send a
message comprising a note (with free-form body and title), link (for
sending a URL), or even a file. The message recipients is typically one
(or several) of the devices known to the user (see the next section for
details), it can also be an email address in which case
<a href="https://www.pushbullet.com">Pushbullet</a> creates and sends an
email to the given address.

## Initialization

The authentication key, as well as the device id, nicknames for the
devices and default device can all be declared in several ways.

One possibility is to use a file <code>.rpushbullet.json</code> in the
<code>$HOME</code> directory. (Note that on Windows you may have to set
the <code>$HOME</code> environment variable.) It uses the JSON format
which uses a key:value pair notation; values may be arrays. A simple
example follows.

<pre>
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
</pre>

The entire block is delimited by a pair of curly braces. Within the
curly braces we have “key” and “devices” which are mandatory. Here “key”
is expected to contain a single value; “devices” can be an array which
is denoted by square brackets. Optionally a “names” single value or
array can be used to assign nicknames to the devices. Lastly, a
“defaultdevice” can be designated as well.

However, use of a configuration file is not mandatory. The arguments can
also be supplied as global options (which could be done in the usual R
startup files, see <code>Startup</code> for details) as well as via
standard function arguments when calling the corresponding functions.
When using global options, use the names <code>rpushbullet.key</code>,
<code>rpushbullet.devices</code>, <code>rpushbullet.names</code>, and
<code>rpushbullet.defaultdevice</code> corresponding to the entries in
the JSON file shown above.

The <code>curl</code> binary is required, and is located at package
initialization, along with the other load-time intializations described
here. It is therefore strongly recommended to attach the package in the
normal way via <code>library(RPushbullet)</code> rather than trying to
access functions from the package namespace.

## Author(s)

Dirk Eddelbuettel

## References

See the Pushbullet documentation at the
<a href="https://www.pushbullet.com">Pushbullet website</a>.

## See Also

The documentation for the main function <code>pbPost</code>, as well as
the documentation for <code>pbGetDevices</code>.
