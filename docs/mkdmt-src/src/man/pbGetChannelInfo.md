## Details for a channel

### Description

Details for a channel

### Usage

    pbGetChannelInfo(channel, no_recent_pushes = FALSE)

    ## Default S3 method:
    pbGetChannelInfo(channel, no_recent_pushes = FALSE)

    ## S3 method for class 'pbChannelInfo'
    print(x, ...)

    ## S3 method for class 'pbChannelInfo'
    summary(object, ...)

### Arguments

| Argument           | Description                                                                                                                           |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `channel`          | The name of a Pushbullet channel as a string                                                                                          |
| `no_recent_pushes` | Should the returned returned object exclude recent pushs? `FALSE` (the default) will return up to 10 pushes. `TRUE` will exclude them |
| `x`                | Default object for `print` method                                                                                                     |
| `...`              | Other optional arguments                                                                                                              |
| `object`           | Default object for `summary` method                                                                                                   |

### Value

a list with infoabout a channel

### Examples

    xkcd <- pbGetChannelInfo("xkcd", TRUE)
    summary(xkcd)
