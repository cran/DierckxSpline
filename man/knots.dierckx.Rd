\name{knots.dierckx}
%\alias{knots}
\alias{knots.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Extract the knots from a dierckx object}
\description{
  Extract either all or only the interior knots from an object of class
  dierckx.  
}
\usage{
\method{knots}{dierckx}(Fn, interior=TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Fn}{an object of class dierckx}
  \item{interior}{
    logical:

    if TRUE, the first Fn[["k"]]+1 of Fn[["knots"]] are dropped, and the
    next Fn[["g"]] are returned.

    Otherwise, the first Fn[["n"]] of Fn[["knots"]] are returned.  
  }
  \item{\dots}{ignored} 
}
\details{
  The knots component of at least some dierckx objects is of length
  Fn[["nest"]], but only the first Fn[["n"]] of them are actually used.
  Moreover, the first and last Fn[["k"]]+1 of them are end knots while
  the remaining Fn[["g"]] are interior knots.  
}
\value{
  Numeric vector.  If 'interior' is TRUE, this vector has length =
  Fn[["g"]].  Otherwise, it has length Fn[["n"]].  
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{
  \code{\link{curfit}},
  \code{\link{concon}},
  \code{\link[stats]{spline}},
  \code{\link[stats]{smooth.spline}}}
\examples{
x <- 0:24
y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
       13.4,12.8,13.1,13.0,14.0,13.0,13.5,
       10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)

z1 <- curfit(x, y, method = "ss", s = 0, k = 3)

knots(z1)
knots(z1, interior=FALSE) # to see all knots 
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{optimize}
