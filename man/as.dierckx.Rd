\name{as.dierckx}
\alias{as.dierckx}
\alias{as.dierckx.fd}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Convert a spline object to class 'dierckx'
}
\description{
  Translate a spline object of another class into DierckxSpline (class
  \code{dierckx}) format.
}
\usage{
as.dierckx(x)
\method{as.dierckx}{fd}(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
    an object to be converted to class \code{dierckx}.
  }
}
\details{
  The behavior depends on the \code{class} and nature of \code{x}.  In
  particular, the \code{DierckxSpline} package only supports splines of
  order between 2 and  6, degree between 1 and 5, for linear through
  quintic splines.  Other packages, e.g., \code{fda} support splines
  over a wider range and non-spline basis functions such as finite
  Fourier series.  When these are encountered, \code{as.dierckx} throws
  an error.

  \itemize{
    \item{as.dierckx.fd}{
      The following describes how the components of a \code{dierckx}
      object are constructed from a spline object of a different class:

      \itemize{
	\item{x}{Restored from the knots.}
	\item{y}{
	  Restored from spline predictions at the restored values of
	  knot locations 'x'.
	}
	\item{w}{lost.  Restored as rep(1, length(x)).}
	\item{from, to}{fd[["basis"]][["rangeval"]] }
	\item{k}{
	  coded indirectly as fd[["basis"]][["nbasis"]] -
	  length(fd[["basis"]][["params"]]) - 1.
	}
	\item{s}{lost, restored as 0.}
	\item{nest}{lost, restored as length(x) + k + 1}
	\item{n}{
	  coded indirectly as 2*fd[["basis"]][["nbasis"]] -
	  length(fd[["basis"]][["params"]]).
	}
	\item{knots}{
	  The end knots are stored (unreplicated) in
	  fd[["basis"]][["rangeval"]], while the interior knots are
	  stored   in fd[["basis"]][["params"]].
	}
	\item{fp}{lost.  Restored as 0.}
	\item{wrk, lwrk, iwrk}{
	  lost.  Restore by refitting to the knots.
	}
	\item{ier}{lost.  Restored as 0.}
	\item{message}{lost.  Restored as character(0).}
	\item{g}{
	  stored indirectly as length(fd[["basis"]][["params"]]).
	}
	\item{method}{lost.  Restored as "ss".}
	\item{periodic}{
	  'dierckx2fd' only translates 'dierckx' objects
	  with coincident boundary knots.  Therefore, 'periodic' is
	  restored as FALSE.
	}
	\item{routine}{lost.  Restored as 'curfit.default'.}
	\item{xlab}{fd[["fdnames"]][["args"]]}
	\item{ylab}{fd[["fdnames"]][["funs"]]}
      }
    }
  }
}
\value{
  \code{as.fd.dierckx} converts an object of class 'dierckx' into one of
  class \code{fd}.
}
\references{
  Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines},
  Oxford Science Publications.

  Ramsay, James O., and Silverman, Bernard W. (2006), \emph{Functional
    Data Analysis, 2nd ed.}, Springer, New York.

  Ramsay, James O., and Silverman, Bernard W. (2002), \emph{Applied
    Functional Data Analysis}, Springer, New York.
}
\author{Spencer Graves}
\seealso{
  \code{\link[fda]{as.fd}}
  \code{\link[fda]{fd}}
  \code{\link{curfit}}
}
\examples{
x <- 0:24
y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
       13.4,12.8,13.1,13.0,14.0,13.0,13.5,
       10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)
curfit.xy <- curfit(x, y, s=0)

if(require(fda)) {
  curfit.fd <- as.fd(curfit.xy)
  plot(curfit.fd) # as an 'fd' object
  points(x, y) # Curve goes through the points.

  x. <- seq(0, 24, length=241)
  pred.y <- predict(curfit.xy, x.)
  lines(x., pred.y, lty="dashed", lwd=3, col="blue")
# dierckx and fd objects match.

\dontshow{stopifnot(}
  all.equal(knots(curfit.xy, FALSE), knots(curfit.fd, FALSE))
\dontshow{)}
\dontshow{stopifnot(}
  all.equal(coef(curfit.xy), as.vector(coef(curfit.fd)))
\dontshow{)}

  curfit2 <- as.dierckx(curfit.fd)
  pred.y2 <- predict(curfit2, x.)
  sum(abs(pred.y-pred.y2))/(sum(abs(pred.y)+abs(pred.y2))/2)
# 1.3e-7

\dontshow{stopifnot(}
  all.equal(knots(curfit.xy, FALSE), knots(curfit2, FALSE))
\dontshow{)}
# TRUE
  all.equal(coef(curfit.xy), coef(curfit2))
# "Mean relative  difference: 4.5e-7

  preserved <- c("from", "to", "n", "g", "periodic", "xlim","ylim")
  all.equal(curfit.xy[preserved], curfit2[preserved])
# TRUE
# Other components are NOT preserved in translation
# and so can NOT be restored.
}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{manip}
