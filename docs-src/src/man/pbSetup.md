## Create a JSON config file

### Description

Create a JSON config file

### Usage

    pbSetup(apikey, conffile, defdev)

### Arguments

| Argument   | Description                                                                                                                                                                                                                                |
|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `apikey`   | An *Access Token* provided by Pushbullet (see details). If not provided in the function call, the user will be prompted to enter one.                                                                                                      |
| `conffile` | A string giving the path where the configuration file will be written. RPushbullet will automatically attempt load from the default location `~/.rpushbullet.json` (which can be changed via a `rpushbullet.dotfile`) entry in `options`). |
| `defdev`   | An optional value for the default device; if missing (or `NA`) then an interactive prompt is used.                                                                                                                                         |

### Details

This function writes a simple default configuration file based on a
given apikey. It is intended to be run once to help new users setup
RPushbullet. Running multiple times without overriding the `config_file`
parameter will overwrite the default file. An *Access Token* may be
obtained for free by logging into the Pushbullet website, going to
<https://www.pushbullet.com/#settings>, and clicking on "Create Access
Token".

### Value

`NULL` is returned invisibly, but the function is called for its side
effect of creating the configuration file.

### Author(s)

Seth Wenchel and Dirk Eddelbuettel

### Examples

    ## Not run: 
    # Interactive mode.  Just follow the prompts.
    pbSetup()

    ## End(Not run)
