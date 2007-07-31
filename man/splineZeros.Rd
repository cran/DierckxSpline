\name{splineZeros}
\alias{splineZeros}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Find the zeros of a spline}
\description{
  Find the zeros of a spline starting with the control polygon.  
}
\usage{
splineZeros(object, maxiter) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{An object of class \code{dierckx}.}
  \item{maxiter}{
    maximum number of iterations allowed so the signs of the control
    polygon match those of the spline.  
  }
}
\details{
  As described in Dierckx(1993, pp. 16-22):  
  
  1.  cP <- controlPolygon(object)

  2.  Evaluate the spline at the zeros of the control polygon.  
  
  3.  While there are sign changes in the control polygon that are not
  matched by sign changes in the spline, insert knots, recompute the
  control polygon and the spline at the zeros of the control polygon.
  Iterate.

  4.  Use 'uniroot' to obtain the zero in each interval containing a
  sign change in the spline.  
}
\value{
  a matrix with one column for each of the outputs of 'uniroot':  

  \itemize{
    \item{root}{estimated zero}
    \item{f.root}{value of the spline at 'root'}
    \item{iter}{number of iterations required by 'uniroot'}
    \item{estim.prec}{estimated precision for [root]}
    }
}
\references{
Dierckx, P. (1993) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Spencer Graves}
\seealso{\code{\link{curfit}},\code{\link{insert.dierckx}},\code{\link{predict.dierckx}},\code{\link[stats]{uniroot}}}
\examples{
xi <- 1:10
yi <- sin(xi) 
spli <- curfit(xi, yi, s=10)

cPi <- controlPolygon(spli)
x. <- seq(1, 10, length=201) 
plot(x., predict(spli, x.), type="l")
points(xi, yi)

abline(h=0)
lines(cPi[, 1], cPi[, 2], lty=2)
Zeros <- splineZeros(spli)
abline(v=Zeros[, 1])

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{math}
