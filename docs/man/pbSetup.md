

# Create a JSON config file

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

Create a JSON config file

## Usage

<pre><code class='language-R'>pbSetup(apikey, conffile, defdev)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="apikey">apikey</code>
</td>
<td>
An <em>Access Token</em> provided by Pushbullet (see details). If not
provided in the function call, the user will be prompted to enter one.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="conffile">conffile</code>
</td>
<td>
A string giving the path where the configuration file will be written.
RPushbullet will automatically attempt load from the default location
<code>~/.rpushbullet.json</code> (which can be changed via a
<code>rpushbullet.dotfile</code>) entry in <code>options</code>).
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="defdev">defdev</code>
</td>
<td>
An optional value for the default device; if missing (or
<code>NA</code>) then an interactive prompt is used.
</td>
</tr>
</table>

## Details

This function writes a simple default configuration file based on a
given apikey. It is intended to be run once to help new users setup
RPushbullet. Running multiple times without overriding the
<code>config_file</code> parameter will overwrite the default file. An
<em>Access Token</em> may be obtained for free by logging into the
Pushbullet website, going to
<a href="https://www.pushbullet.com/#settings">https://www.pushbullet.com/#settings</a>,
and clicking on "Create Access Token".

## Value

<code>NULL</code> is returned invisibly, but the function is called for
its side effect of creating the configuration file.

## Author(s)

Seth Wenchel and Dirk Eddelbuettel

## Examples

``` r
library("RPushbullet")

# Interactive mode.  Just follow the prompts.
pbSetup()
```
