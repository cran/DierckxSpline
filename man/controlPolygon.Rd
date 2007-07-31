\name{controlPolygon}
\alias{controlPolygon}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Control polygon of a spline 
}
\description{
  The control polygon matches running means of k knots with the spline
  coefficients, where k = the degree of the knots.  See Dierckx(p. 20).
}
\usage{
controlPolygon(object)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
    an object of class 'dierckx' or 'fd'
  }
}
\details{
  Dierckx(p. 20-22, including Figure 1.2) explains how the control
  polygon can help isolate the zeros of a spline.  
}
\value{
  An array of dimension nbasis x 2, where the first column contains
  running means of k knots, and the second is the coefficients of the
  spline.  
}
\references{
Dierckx, P. (1993) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Spencer Graves}
\seealso{
  \code{\link{curfit}},
  \code{\link[fda]{fd}}
}
\examples{
# spline object of Figure 1.2  
knots1.2 <- c(0,0,0,0, 2, 4, 7, 8, 10,10,10,10)
wts <- c(1, 2, 5, -5, 5, -1, 3, 3)

library(fda) 
fig1.2basis <- create.bspline.basis(c(0, 10),
                                    breaks=c(0, 2, 4, 7, 8, 10))
fig1.2a.fda <- fd(c(1, 2, 5, -5, 5, -1, 3, 3), fig1.2basis)
plot(fig1.2a.fda, ylim=c(-5, 5))

# NOTE:
# An attempt to create this Figure using 'curfit'
# failed, because 'curfit' dropped the knots at 2 and 8.

cP <- controlPolygon(fig1.2a.fda)
lines(cP[, 1], cP[, 2], lty="dotted")

fig1.2a.dierckx <- fd2dierckx(fig1.2a.fda)
cPdierckx <- controlPolygon(fig1.2a.dierckx)
all.equal(cP, cPdierckx)
#  "Mean relative  difference: 5.745888e-07"

}
\keyword{smooth}
