

# Details for a channel

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

Details for a channel

## Usage

<pre><code class='language-R'>pbGetChannelInfo(channel, no_recent_pushes = FALSE)

# Default S3 method:
pbGetChannelInfo(channel, no_recent_pushes = FALSE)

# S3 method for class 'pbChannelInfo'
print(x, ...)

# S3 method for class 'pbChannelInfo'
summary(object, ...)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="channel">channel</code>
</td>
<td>
The name of a Pushbullet channel as a string
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="no_recent_pushes">no_recent_pushes</code>
</td>
<td>
Should the returned returned object exclude recent pushs?
<code>FALSE</code> (the default) will return up to 10 pushes.
<code>TRUE</code> will exclude them
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

a list with infoabout a channel

## Examples

``` r
library("RPushbullet")

xkcd <- pbGetChannelInfo("xkcd", TRUE)
summary(xkcd)
```

    Pushbullet User summary for ujxPklLhvyKsjxQWuu7bu8 
     Name: xkcd 
     Description:  Every new xkcd post, pushed right to you. 
     Subscriber Count:  21880 
