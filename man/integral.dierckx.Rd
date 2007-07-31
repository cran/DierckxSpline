\name{integral.dierckx}
\alias{integral}
\alias{integral.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Spline Integration}
\description{
  Calculates the integral of a spline function s(x) of degree k,
  which is given in its normalized b-spline representation
}
\usage{
integral(x, ...)
\method{integral}{dierckx}(x, from = NULL, to = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{An object of class \code{dierckx}.}
  \item{from}{Lower integration bound. If \code{NULL}, the minimum knot
    value is used.}
  \item{to}{Upper integration bound. If \code{NULL}, the maximum knot
    value is used.}
  \item{\dots}{ignored}
}
\details{
  \code{s(x)} is considered to be identically zero outside the interval
  \code{(t(k+1),t(n-k))}, where \code{t} are the knot values. For this reason,
  \code{from} and \code{to} are forced to be in or on the boundaries of
  the knots.
}
\value{
  The value of the integral.
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{\code{\link{curfit}}, \code{\link{deriv.dierckx}}, \code{\link[stats]{spline}}, \code{\link[stats]{smooth.spline}}}
\examples{
x <- seq(0, 1, 0.1)
y <- (1 - x)^3
z <- curfit(x, y, knots = seq(0, 1, 0.2))

plot(x, y, type = "p")
lines(x, fitted(z), col = "blue")

(answer <- integrate(function(x) (1 - x)^3, 0, 1))
#0.25 with absolute error < 2.8e-15
integral(z)-answer$value
# 0

(ans2 <- integrate(function(x) (1 - x)^3, 0.5, 0.6))
#0.009225 with absolute error < 1.0e-16
integral(z, 0.5, 0.6)-ans2$value
# 6e-9
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{math}
