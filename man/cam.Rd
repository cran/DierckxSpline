\name{cam}
\docType{data}
\alias{cam}
\title{
  cam data 
}
\description{
  cam data used in a Dierckx example 
}
\usage{
data(cam)
}
\format{
 a data.frame with 61 observations on one variable:  'X3.109'.
}
\details{
  Dierckx (1993)
}
\source{
  Dierckx, Paul (1993), \emph{Curve and Surface Fitting with Splines},
  Springer.
}
%\seealso{\code{\link{eval.penalty}}}
\examples{
data(cam)
plot(1:61, cam$X3.109)
}
% docclass is function
\keyword{datasets}

