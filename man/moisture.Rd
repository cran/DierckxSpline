\name{moisture}
\docType{data}
\alias{moisture}
\title{
  Volumetric moisture content 
}
\description{
  16 measurements of volumetric moisture content 
}
\usage{
data(moisture)
}
\format{
  a data.frame with the following columns:   

  \item{x}{
    property 
  }
  \item{y}{
    measurement 
  }  
  \item{v}{
    constant 1 
  }  
  \item{w}{
    Weight:  constant 1 except for the first 2 and the last
    observations, being 10, 3, 10, respectively.  
  }  
}
\details{
  Dierckx (1993, Table 7.2, pp. 129-131)

}
\source{
  Dierckx, Paul (1993), \emph{Curve and Surface Fitting with Splines},
  Springer.
}
%\seealso{\code{\link{eval.penalty}}}
\examples{
data(moisture)
moisture # Dierckx, Table 7.2, p. 130
f1 <- with(moisture,
  concon(x, y, w, v, s = 0.2))
f2 <- update(f1, s = 0.04)
f3 <- update(f1, s = 0.0002)

g1 <- with(moisture,
  curfit(x, y, w, method = "ls",
         knots = knots(f1)))
g2 <- update(g1, knots = f2)
g3 <- update(g1, knots = f3)

}
% docclass is function
\keyword{datasets}

