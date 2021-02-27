#!/bin/sh
## cf https://docs.github.com/en/actions/reference/encrypted-secrets

#echo "$TOKENFILE_PASSWORD" | wc
#echo "$TOKENFILE_PASSWORD" | md5sum
#ls -l .rpushbullet.json.gpg

## --batch to prevent interactive command
## --yes to assume "yes" for questions
gpg --verbose --batch --yes --decrypt --passphrase="$TOKENFILE_PASSWORD" \
    --output "${HOME}"/.rpushbullet.json .rpushbullet.json.gpg
#ls -l ${HOME}/.rpushbullet.json
#pwd
