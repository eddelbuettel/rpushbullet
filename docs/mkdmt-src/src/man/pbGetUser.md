## Get info about a user

### Description

Get info about a user

### Usage

    pbGetUser(apikey = .getKey())

    ## Default S3 method:
    pbGetUser(apikey = .getKey())

    ## S3 method for class 'pbUser'
    print(x, ...)

    ## S3 method for class 'pbUser'
    summary(object, ...)

### Arguments

| Argument | Description                                                                                                                                                    |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `apikey` | The API key used to access the service. It can be supplied as an argument here, or via the file `~/.rpushbullet.json` which is read at package initialization. |
| `x`      | Default object for `print` method                                                                                                                              |
| `...`    | Other optional arguments                                                                                                                                       |
| `object` | Default object for `summary` method                                                                                                                            |

### Value

Invisibly returns info about a user

### Examples

    ## Not run: 
    me <- pbGetUser()
    summary(me)

    ## End(Not run)
