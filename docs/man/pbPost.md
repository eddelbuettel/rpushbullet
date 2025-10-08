

# Post a message via Pushbullet

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

This function posts a message to Pushbullet. Different types of messages
are supported: ‘note’, ‘link’, ‘address’, or ‘file’.

## Usage

<pre><code class='language-R'>pbPost(type = c("note", "link", "file"), title = "", body = "",
  url = "", filetype = "text/plain", recipients, email, channel, deviceind,
  apikey = .getKey(), devices = .getDevices(), verbose = FALSE,
  debug = FALSE)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="type">type</code>
</td>
<td>
The type of post: one of ‘note’, ‘link’, or ‘file’.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="title">title</code>
</td>
<td>
The title of the note being posted.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="body">body</code>
</td>
<td>
The body of the note or the (optional) body when the <code>type</code>
is ‘link’.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="url">url</code>
</td>
<td>
The URL of <code>type</code> is ‘link’, or the local path of a file to
be sent if <code>type</code> is ‘file’.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="filetype">filetype</code>
</td>
<td>
The MIME type for the file at <code>url</code> (if <code>type</code> is
‘file’) such as “text/plain” or “image/jpeg”, defaults to “text/plain”.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="recipients">recipients</code>
</td>
<td>
A character or numeric vector indicating the devices this post should go
to. If missing, the default device is looked up from an optional
setting, and if none has been set the push is sent to all devices.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="email">email</code>
</td>
<td>
An alternative way to specify a recipient is to specify an email
address. If both <code>recipients</code> and <code>email</code> are
present, <code>recipients</code> is used.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="channel">channel</code>
</td>
<td>
A channel tag used to specify the name of the channel as the recipient.
If either <code>recipients</code> or <code>email</code> are present,
they will take precedence over <code>channel</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="deviceind">deviceind</code>
</td>
<td>
(Deprecated) The index (or a vector/list of indices) of the device(s) in
the list of devices.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="apikey">apikey</code>
</td>
<td>
The API key used to access the service. It can be supplied as an
argument here, via the global option <code>rpushbullet.key</code>, or
via the file <code>~/.rpushbullet.json</code> which is read at package
initialization (and, if found, also sets the global option).
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="devices">devices</code>
</td>
<td>
The device to which this post is pushed. It can be supplied as an
argument here, or via the file <code>~/.rpushbullet.json</code> which is
read at package initialization.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="verbose">verbose</code>
</td>
<td>
Boolean switch to add additional output
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="debug">debug</code>
</td>
<td>
Boolean switch to add even more debugging output
</td>
</tr>
</table>

## Details

This function invokes the ‘pushes’ functionality of the Pushbullet API;
see
<a href="https://docs.pushbullet.com/">https://docs.pushbullet.com/</a>
for more details.

When a ‘note’ is pushed, the recipient receives the title and body of
the note. If a ‘link’ is pushed, the recipient’s web browser is opened
at the given URL. If an ‘address’ is pushed, the recipient’s web browser
is opened in map mode at the given address.

If ‘recipients’ argument is missing, the post is pushed to <em>all</em>
devices in accordance with the API definition. If ‘recipients’ is text
vector, it matched against the device names (from either the config file
or a corresponding option). Lastly, if ‘recipients’ is a numeric vector,
the post is pushed the corresponding elements in the devices vector.

In other words, the default of value of no specified recipients results
in sending to all devices. If you want a particular subset of devices
you have to specify it name or index. A default device can be set in the
configuration file, or as a global option. If none is set, zero is used
as a code to imply ‘all’ devices.

The earlier argument <code>deviceind</code> is now deprecated and will
be removed in a later release.

In some cases servers may prefer the older ‘HTTP 1.1’ standard (as
opposed to the newer ‘HTTP 2.0’ set by <code>curl</code>). Setting the
option “rpushbullet.useHTTP11” to <code>TRUE</code> will enable use of
‘HTTP 1.1’.

## Value

A JSON result record is return invisibly

## Author(s)

Dirk Eddelbuettel

## Examples

``` r
library("RPushbullet")

# A note
pbPost("note", "A Simple Test", "We think this should work.\nWe really do.")

# A URL -- should open browser
pbPost(type="link", title="Some title", body="Some URL",
       url="https://cran.r-project.org/package=RPushbullet")

# A file
pbPost(type="file", url=system.file("DESCRIPTION", package="RPushbullet"))
```
