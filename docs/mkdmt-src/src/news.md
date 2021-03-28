### Version 0.3.4 (2021-03-01)

-   Return code checking using error code content if it exists (Thomas
    Shafer in
    [\#64](https://github.com/eddelbuettel/rpushbullet/pull/64)).

-   Enabled GitHub Actions with encrypted JSON file for API access.

-   Added a package documentation website.

### Version 0.3.3 (2020-01-18)

-   UTF-8 encoding is now used (Chan-Yub Park in
    [\#55](https://github.com/eddelbuettel/rpushbullet/pull/55)).

-   Curl can use HTTP/1.1 (Alexandre Shannon in
    [\#59](https://github.com/eddelbuettel/rpushbullet/pull/59) fixing
    [\#57](https://github.com/eddelbuettel/rpushbullet/issues/57), plus
    Dirk in [\#60](https://github.com/eddelbuettel/rpushbullet/pull/60)
    making it optional).

### Version 0.3.2 (2019-07-21)

-   The Travis setup was robustified with respect to the token need to
    run tests (Dirk in
    [\#48](https://github.com/eddelbuettel/rpushbullet/pull/48))

-   The configuration file is now readable only by the user (Colin
    Gillespie in
    [\#50](https://github.com/eddelbuettel/rpushbullet/pull/50))

-   At startup initialization is now more consistent (Colin Gillespie in
    [\#53](https://github.com/eddelbuettel/rpushbullet/pull/53) fixing
    [\#52](https://github.com/eddelbuettel/rpushbullet/issues/52))

-   A new function to fetch prior posts was added (Chan-Yub Park in
    [\#54](https://github.com/eddelbuettel/rpushbullet/pull/54)).

### Version 0.3.1 (2017-02-17)

-   The target device designation was corrected
    ([\#39](https://github.com/eddelbuettel/rpushbullet/pull/39)).

-   Three new (unexported) helper functions test now test the validity
    of the api key, device and channel (Seth in
    [\#41](https://github.com/eddelbuettel/rpushbullet/pull/41)).

-   The `summary` method for the `pbDevices` class was corrected (Seth
    in [\#43](https://github.com/eddelbuettel/rpushbullet/pull/43)).

-   New helper functions `pbValidateConf`, `pbGetUser`,
    `pbGetChannelInfo` were added (Seth in
    [\#44](https://github.com/eddelbuettel/rpushbullet/pull/44) closing
    [\#40](https://github.com/eddelbuettel/rpushbullet/issues/40)).

-   New classes `pbUser` and `pbChannelInfo` were added (Seth in
    [\#44](https://github.com/eddelbuettel/rpushbullet/pull/44)).

-   Travis CI tests (and
    [[covr]{.pkg}](https://CRAN.R-project.org/package=covr) coverage
    analysis) are now enabled via an encrypted config file
    ([\#45](https://github.com/eddelbuettel/rpushbullet/pull/45)).

### Version 0.3.0 (2017-02-03)

-   The `curl` binary use was replaced by use of the
    [[curl]{.pkg}](https://CRAN.R-project.org/package=curl) package;
    several new helper functions added (PRs
    [\#30](https://github.com/eddelbuettel/rpushbullet/pull/30),
    [\#36](https://github.com/eddelbuettel/rpushbullet/pull/36) by Seth
    closing
    [\#29](https://github.com/eddelbuettel/rpushbullet/issues/29))

-   Use of [[RJSONIO]{.pkg}](https://CRAN.R-project.org/package=RJSONIO)
    was replaced by use of
    [[jsonlite]{.pkg}](https://CRAN.R-project.org/package=jsonlite) (PR
    [\#32](https://github.com/eddelbuettel/rpushbullet/pull/32) by Seth
    closing
    [\#31](https://github.com/eddelbuettel/rpushbullet/issues/31))

-   A new function `pbSetup` was added to aid creating the resource file
    (PRs [\#34](https://github.com/eddelbuettel/rpushbullet/pull/34),
    [\#37](https://github.com/eddelbuettel/rpushbullet/pull/37) by Seth
    and Dirk)

-   The package intialization was refactored so that non-loading calls
    such as `RPushbullet::pbPost(...)` now work
    ([\#33](https://github.com/eddelbuettel/rpushbullet/pull/33) closing
    [\#26](https://github.com/eddelbuettel/rpushbullet/issues/26))

-   The test suite was updated and extended

-   The Travis script was updated use run.sh

-   DESCRIPTION, README.md and other files were updated for current
    `R CMD check` standards

-   Deprecated parts such as \'type=address\' were removed, and the
    documentation was updated accordingly.

-   Coverage support was added (in a \'on-demand\' setting as automated
    runs would need a Pushbullet API token)

### Version 0.2.0 (2015-02-07)

-   Added support for Pushbullet \'channels\' (once again thanks to Mike
    Birdgeneau for the initial push on this; cf
    [\#18](https://github.com/eddelbuettel/rpushbullet/issues/18))

-   Support for pushes was solidified: proper choices of either device,
    email or channel should work in all cases

-   S3 methods are now properly exports (thanks to Henrik Bengtsson)

-   File transfer mode has been improved / corrected (thanks to Mike
    Birdgeneau)

-   The regression test suite was expanded and robustified

-   This NEWS file was added. Better late than never.

### Version 0.1.1 (2014-11-03)

-   Corrections to the file upload method

### Version 0.1.0 (2014-10-10)

-   Expanded documentation on how to set API keys, device keys and
    default settings

-   Email support was added

-   Regression tests for types 'link' and 'file' were added.

-   Support for file transfers was added by Mike Birgeneau

-   Initialization was rewritten / solidified

### Version 0.0.2 (2014-06-02)

-   Improved detection of `curl` binary at startup

-   Package environment now in `.pkgenv`

-   Added simple test script

### Version 0.0.1 (2014-06-02)

-   Initial version
