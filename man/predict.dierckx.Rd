\name{predict.dierckx}
\alias{predict.dierckx}
\title{
  Predict method for object of class 'dierckx'.
}
\description{
  Evaluate the spline for a desired set of x values.  
}
\usage{
  \method{predict}{dierckx}(object, newdata, ...)
}
\arguments{
  \item{object}{
    An object of class 'dierckx'.
  }
  \item{newdata}{
    an optional numeric vector at which 'dierckx' spline predictions are
    desired.  
  }
  \item{\dots}{Ignored.}
}
\details{
  if newdata is provided, evaluate the spline at newdata and return the
  predictions.  Else, return fitted(object).  
}
\value{
  A numeric vector giving spline predictions for 'newdata' if provided
  or for each distinct level of 'x' in the spline fit.  
}
\author{Sundar Dorai-Raj and Spencer Graves}
\references{
Dierckx, P. (1993) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.  
}

\seealso{
  \code{\link{curfit}}
}
\examples{
x <- 0:24
y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
       13.4,12.8,13.1,13.0,14.0,13.0,13.5,
       10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)
fitSS0 <- curfit(x, y, s=0)
predict(fitSS0, seq(2, 3, length=5))
}
\keyword{smooth}
