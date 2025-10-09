#!/bin/sh

test -d docs || exit 0

sed -i -e's/Changes in version/Version/g' docs/NEWS/index.html

## Turns
##   txt <- r"{<a href="https://github.com/eddelbuettel/rpushbullet/pull/55">[#55](https://github.com/eddelbuettel/rpushbullet/issues/55)</a>).}"
## into
##     "<a href=\"https://github.com/eddelbuettel/rpushbullet/pull/55\">#55</a>)."
#Rscript -e 'writeLines(sub("\\[\\#(\\d+)\\]\\(https://github.com/eddelbuettel/rpushbullet/(issues|pull)/\\d+\\)", "#\\1", readLines("docs/NEWS/index.html")), "docs/NEWS/index.html")'

sed -i -e's/\[\(\#[0-9]\+\)\](https:\/\/github\.com\/eddelbuettel\/rpushbullet\/[a-z]\+\/[0-9]\+)/\1/g' docs/NEWS/index.html
