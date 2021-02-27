## Get messages posted via Pushbullet

### Description

This function gets messages posted to Pushbullet.

### Usage

    pbGetPosts(apikey = .getKey(), limit = 10)

### Arguments

| Argument | Description                                                                                                                                                                                                                                                                                                         |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `apikey` | The API key used to access the service. It can be supplied as an argument here, via the global option `rpushbullet.key`, or via the file `~/.rpushbullet.json` which is read at package initialization (and, if found, also sets the global option). `~/.rpushbullet.json` which is read at package initialization. |
| `limit`  | Limit number of post. Default is 10.                                                                                                                                                                                                                                                                                |

### Value

A data.frame result record is returned

### Author(s)

Chan-Yub Park

### Examples

    ## Not run: 
    pbGetPosts()

    ## End(Not run)
