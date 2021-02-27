## Check if a configuration is valid

### Description

Check if a configuration is valid

### Usage

    pbValidateConf(conf = NULL)

### Arguments

| Argument | Description                                                                                                                                              |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `conf`   | Either a file path (like `~/.rpushbullet.json`) or a JSON string. If `NULL` (the default), the value of `getOption("rpushbullet.dotfile")` will be used. |

### Value

`TRUE` if both the api key and *all* devices are vaild. `FALSE`
otherwise.

### Examples

    pbValidateConf('{"key":"a_fake_key","devices":["dev_iden1","dev_iden2"]}')
