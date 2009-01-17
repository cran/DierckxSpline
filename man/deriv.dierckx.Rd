\name{deriv.dierckx}
\alias{deriv}
\alias{deriv.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Spline Differentiation}
\description{
  Evaluates in a number of points x(i),i=1,2,...,m
  the derivative of order nu of a spline s(x) of degree k,given in
  its b-spline representation.
}
\usage{
\method{deriv}{dierckx}(expr, at = NULL, order = 1, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{expr}{An object of class \code{dierckx}.}
  \item{at}{Optional numeric vector where the derivatives should be
    calculated. If missing, the initial abscissa values are used.}
  \item{order}{Order of the derivative of the derivative to
    calculate. Default is 1 (first derivative). Valid values are
    0<=order<=k.}
  \item{\dots}{ignored}
}
\value{
  A numeric vector the same length as \code{at} containing the derivatives.
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{\code{\link{curfit}}, \code{\link{integral.dierckx}}, \code{\link[stats]{spline}}, \code{\link[stats]{smooth.spline}}}
\examples{

x <- seq(0, 1, 0.1)
y <- (1 - x)^3
z <- curfit(x, y, method = "ls", knots = seq(0, 1, 0.2), k = 3)

plot(x, y, type = "p")
lines(x, fitted(z), col = "blue")

D1 <- deriv(z, order = 1)
D2 <- deriv(~(1 - x)^3, "x", func = TRUE)(z$x)
D3 <- numericDeriv(quote((1 - x)^3), "x")
D4 <- -3 * (1 - z$x)^2
cbind(D1 = D1,
     D2 = attr(D2, "gradient")[, 1],
     D3 = diag(attr(D3, "gradient")),
     D4 = D4)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{math}
