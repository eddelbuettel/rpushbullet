## Get registered Pushbullet devices

### Description

Retrieve the list of devices registered for the given API key.

### Usage

    pbGetDevices(apikey = .getKey())

    ## Default S3 method:
    pbGetDevices(apikey = .getKey())

    ## S3 method for class 'pbDevices'
    print(x, ...)

    ## S3 method for class 'pbDevices'
    summary(object, ...)

### Arguments

| Argument | Description                                                                                                                                                    |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `apikey` | The API key used to access the service. It can be supplied as an argument here, or via the file `~/.rpushbullet.json` which is read at package initialization. |
| `x`      | Default object for `print` method                                                                                                                              |
| `...`    | Other optional arguments                                                                                                                                       |
| `object` | Default object for `summary` method                                                                                                                            |

### Details

This function invokes the ‘devices’ functionality of the Pushbullet API;
see <https://docs.pushbullet.com/v2/devices> for more details.

### Value

The resulting JSON record is converted to a list and returned as a
`pbDevices` object with appropriate `print` and `summary` methods.

### Author(s)

Dirk Eddelbuettel
