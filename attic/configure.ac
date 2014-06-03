
## Process this file with autoconf to produce a configure script.
##
## Configure.ac for RPushbullet
##
## Copyright (C) 2014 Dirk Eddelbuettel
##
## Licensed under GNU GPL 2 or later

# The version set here will propagate to other files from here
AC_INIT([RPushbullet], 0.0.2)

## We need curl to access the Pushbullet interface
##
## Check for non-standard programs: curl
AC_PATH_PROG([CURL], [curl])

## If curl was found, we will use it
if test "${CURL}" != ""; then
    AC_MSG_RESULT([curl found, proceeding with installation])
else
    AC_MSG_ERROR([curl not found, is it installed?])
fi

