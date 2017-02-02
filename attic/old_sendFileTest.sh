#!/bin/bash

key=$(r -ljsonlite -e 'cat(fromJSON("~/.rpushbullet.json")$key)')

res=$(curl -s -u ${key}: -X POST https://api.pushbullet.com/v2/upload-request -d ~/git/rpushbullet/DESCRIPTION -d file_type=text/plain)

echo ${res}
