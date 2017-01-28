\name{NEWS}
\title{News for Package \pkg{RPushbullet}}
\newcommand{\ghpr}{\href{https://github.com/eddelbuettel/rpushbullet/pull/#1}{##1}}
\newcommand{\ghit}{\href{https://github.com/eddelbuettel/rpushbullet/issues/#1}{##1}}

\section{Changes in version 0.3.0 (2017-01-28)}{
  \itemize{
    \item The `curl` binary use was replaced by use of the
    \CRANpkg{curl} package (PR \ghpr{30} by Seth)
    \item Use of \CRANpkg{RJSONIO} was switched to use of
    \CRANpkg{jsonlite} (PR \ghpr{32} by Seth)
    \item Coverage support was added (in a 'on-demand' setting as
    automated runs would need a Pushbullet API token)
  }
}

\section{Changes in version 0.2.0 (2015-02-07)}{
  \itemize{
    \item Added support for Pushbullet 'channels' (once again thanks to
    Mike Birdgeneau for the initial push on this)
    \item Support for pushes was solidified: proper choices of either
    device, email or channel should work in all cases
    \item S3 methods are now properly exports (thanks to Henrik
    Bengtsson)
    \item File transfer mode has been improved / corrected (thanks to
    Mike Birdgeneau)
    \item The regression test suite was expanded and robustified
    \item This NEWS file was added. Better late than never.
  }
}

\section{Changes in version 0.1.1 (2014-11-03)}{
  \itemize{
    \item{Corrections to the file upload method}
  }
}

\section{Changes in version 0.1.0 (2014-10-10)}{
  \itemize{
    \item{Expanded documentation on how to set API keys, device keys and
      default settings}
    \item{Email support was added}
    \item{Regression tests for types \sQuote{link} and \sQuote{file}
      were added.}
    \item{Support for file transfers was added by Mike Birgeneau}
    \item{Initialization was rewritten / solidified}
  }
}

\section{Changes in version 0.0.2 (2014-06-02)}{
  \itemize{
    \item{Improved detection of \code{curl} binary at startup}
    \item{Package environment now in \code{.pkgenv}}
    \item{Added simple test script}
  }
}

\section{Changes in version 0.0.1 (2014-06-02)}{
  \itemize{
    \item{Initial version}
  }
}
