

# Get messages posted via Pushbullet

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

This function gets messages posted to Pushbullet.

## Usage

<pre><code class='language-R'>pbGetPosts(apikey = .getKey(), limit = 10)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="apikey">apikey</code>
</td>
<td>
The API key used to access the service. It can be supplied as an
argument here, via the global option <code>rpushbullet.key</code>, or
via the file <code>~/.rpushbullet.json</code> which is read at package
initialization (and, if found, also sets the global option).
<code>~/.rpushbullet.json</code> which is read at package
initialization.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="limit">limit</code>
</td>
<td>
Limit number of post. Default is 10.
</td>
</tr>
</table>

## Value

A data.frame result record is returned

## Author(s)

Chan-Yub Park

## Examples

``` r
library("RPushbullet")

pbGetPosts()
```
