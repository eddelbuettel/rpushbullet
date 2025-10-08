

# Get info about a user

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

Get info about a user

## Usage

<pre><code class='language-R'>pbGetUser(apikey = .getKey())

# Default S3 method:
pbGetUser(apikey = .getKey())

# S3 method for class 'pbUser'
print(x, ...)

# S3 method for class 'pbUser'
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

## Value

Invisibly returns info about a user

## Examples

``` r
library("RPushbullet")

me <- pbGetUser()
summary(me)
```
