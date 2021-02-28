## Post a message via Pushbullet

### Description

This function posts a message to Pushbullet. Different types of messages
are supported: ‘note’, ‘link’, ‘address’, or ‘file’.

### Usage

    pbPost(type = c("note", "link", "file"), title = "", body = "",
      url = "", filetype = "text/plain", recipients, email, channel, deviceind,
      apikey = .getKey(), devices = .getDevices(), verbose = FALSE,
      debug = FALSE)

### Arguments

| Argument     | Description                                                                                                                                                                                                                                          |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `type`       | The type of post: one of ‘note’, ‘link’, or ‘file’.                                                                                                                                                                                                  |
| `title`      | The title of the note being posted.                                                                                                                                                                                                                  |
| `body`       | The body of the note or the (optional) body when the `type` is ‘link’.                                                                                                                                                                               |
| `url`        | The URL of `type` is ‘link’, or the local path of a file to be sent if `type` is ‘file’.                                                                                                                                                             |
| `filetype`   | The MIME type for the file at `url` (if `type` is ‘file’) such as “text/plain” or “image/jpeg”, defaults to “text/plain”.                                                                                                                            |
| `recipients` | A character or numeric vector indicating the devices this post should go to. If missing, the default device is looked up from an optional setting, and if none has been set the push is sent to all devices.                                         |
| `email`      | An alternative way to specify a recipient is to specify an email address. If both `recipients` and `email` are present, `recipients` is used.                                                                                                        |
| `channel`    | A channel tag used to specify the name of the channel as the recipient. If either `recipients` or `email` are present, they will take precedence over `channel`.                                                                                     |
| `deviceind`  | (Deprecated) The index (or a vector/list of indices) of the device(s) in the list of devices.                                                                                                                                                        |
| `apikey`     | The API key used to access the service. It can be supplied as an argument here, via the global option `rpushbullet.key`, or via the file `~/.rpushbullet.json` which is read at package initialization (and, if found, also sets the global option). |
| `devices`    | The device to which this post is pushed. It can be supplied as an argument here, or via the file `~/.rpushbullet.json` which is read at package initialization.                                                                                      |
| `verbose`    | Boolean switch to add additional output                                                                                                                                                                                                              |
| `debug`      | Boolean switch to add even more debugging output                                                                                                                                                                                                     |

### Details

This function invokes the ‘pushes’ functionality of the Pushbullet API;
see <https://docs.pushbullet.com/> for more details.

When a ‘note’ is pushed, the recipient receives the title and body of
the note. If a ‘link’ is pushed, the recipient's web browser is opened
at the given URL. If an ‘address’ is pushed, the recipient's web browser
is opened in map mode at the given address.

If ‘recipients’ argument is missing, the post is pushed to *all* devices
in accordance with the API definition. If ‘recipients’ is text vector,
it matched against the device names (from either the config file or a
corresponding option). Lastly, if ‘recipients’ is a numeric vector, the
post is pushed the corresponding elements in the devices vector.

In other words, the default of value of no specified recipients results
in sending to all devices. If you want a particular subset of devices
you have to specify it name or index. A default device can be set in the
configuration file, or as a global option. If none is set, zero is used
as a code to imply ‘all’ devices.

The earlier argument `deviceind` is now deprecated and will be removed
in a later release.

In some cases servers may prefer the older ‘HTTP 1.1’ standard (as
opposed to the newer ‘HTTP 2.0’ set by `curl`). Setting the option
“rpushbullet.useHTTP11” to `TRUE` will enable use of ‘HTTP 1.1’.

### Value

A JSON result record is return invisibly

### Author(s)

Dirk Eddelbuettel

### Examples

    ## Not run: 
    # A note
    pbPost("note", "A Simple Test", "We think this should work.\nWe really do.")

    # A URL -- should open browser
    pbPost(type="link", title="Some title", body="Some URL",
           url="https://cran.r-project.org/package=RPushbullet")

    # A file
    pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"))

    ## End(Not run)
