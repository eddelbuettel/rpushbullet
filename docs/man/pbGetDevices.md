

# Get registered Pushbullet devices

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

Retrieve the list of devices registered for the given API key.

## Usage

<pre><code class='language-R'>pbGetDevices(apikey = .getKey())

# Default S3 method:
pbGetDevices(apikey = .getKey())

# S3 method for class 'pbDevices'
print(x, ...)

# S3 method for class 'pbDevices'
summary(object, ...)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="apikey">apikey</code>
</td>
<td>
The API key used to access the service. It can be supplied as an
argument here, or via the file <code>~/.rpushbullet.json</code> which is
read at package initialization.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="x">x</code>
</td>
<td>
Default object for <code>print</code> method
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
Other optional arguments
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="object">object</code>
</td>
<td>
Default object for <code>summary</code> method
</td>
</tr>
</table>

## Details

This function invokes the ‘devices’ functionality of the Pushbullet API;
see
<a href="https://docs.pushbullet.com">https://docs.pushbullet.com</a>
for more details.

## Value

The resulting JSON record is converted to a list and returned as a
<code>pbDevices</code> object with appropriate <code>print</code> and
<code>summary</code> methods.

## Author(s)

Dirk Eddelbuettel
