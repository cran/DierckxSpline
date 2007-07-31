\name{insert.dierckx}
\alias{insert}
\alias{insert.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Spline Knot Insertion}
\description{
  Inserts a knot into a spline object.
}
\usage{
insert(object, ...)
\method{insert}{dierckx}(object, at, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{An object of class \code{dierckx}.}
  \item{at}{
    A vector of knots to insert.  If missing, it uses the midpoints of
    sort(unique(knots(object, interior=FALSE))).   
  }
  \item{\dots}{ignored}
}
\details{  
  See Dierckx (1993, pp. 16-22, sec. 1.3.4-1.3.6).  
}
\value{
  An updated spline representation.
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{\code{\link{curfit}}}
\examples{
xi <- 1:10
yi <- sin(xi) 
spli <- curfit(xi, yi, s=10)
plot(xi, yi) 
lines(spli)

spli2 <- insert(spli)
lines(spli2, col="red")
kni <- knots(spli, FALSE) # 1 1 1 1 10 10 10 10 
all.equal(c(kni[1:4], 5.5, kni[5:8]), knots(spli2, FALSE))
# add 1 knot at 5.5  
ci <- coef(spli)
ci2 <- coef(spli2)
all.equal(c(ci[1], 0.5*(ci[-1]+ci[-4]), ci[4]), ci2)
# "Mean relative  difference: 2.700131e-08"
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{math}
