

# Check if a configuration is valid

[**Source code**](https://github.com/eddelbuettel/rpushbullet/tree/master/R/#L)

## Description

Check if a configuration is valid

## Usage

<pre><code class='language-R'>pbValidateConf(conf = NULL)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="conf">conf</code>
</td>
<td>
Either a file path (like <code>~/.rpushbullet.json</code>) or a JSON
string. If <code>NULL</code> (the default), the value of
<code>getOption(“rpushbullet.dotfile”)</code> will be used.
</td>
</tr>
</table>

## Value

<code>TRUE</code> if both the api key and <em>all</em> devices are
vaild. <code>FALSE</code> otherwise.

## Examples

``` r
library("RPushbullet")

pbValidateConf('{"key":"a_fake_key","devices":["dev_iden1","dev_iden2"]}')
```

    [1] FALSE
