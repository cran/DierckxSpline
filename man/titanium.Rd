\name{titanium}
\docType{data}
\alias{titanium}
\title{
  titanium heat data
}
\description{
  49 values expressing a thermal property of titanium.
}
\usage{
data(titanium)
}
\format{
  a data.frame with the following columns:

  \itemize{
    \item{x}{
      Temperature (in unknown units.  The primary source, de Boor and
      Rice (1968), does not say.  However, standard practice with these
      kinds of experimens would be to record data like this in degrees
      Kelvin, and the numbers seem consistent with that practice.)
    }
    \item{y}{physical property}
    \item{yhat}{predictions from some method}
    \item{residual}{100*(y-yhat)}
  }
}
\details{
  Famous example used by de Boor and Rice (1968), Jupp (1978), Dierckx
  (1993) and perhaps others.  (de Boor and Rice do not mention the
  source nor provide other information on the units or how the data were
  collected.)
}
\source{
  de Boor, C., and Rice, J. R. (1986), Least-squares cubic spline
  approximation.  II:  variable knots.  \emph{Report CSD TR 21},
  Purdue U., Lafayette, IN.  (available from http://
  citeseer.ist.psu.edu/cache/papers/cs/24666/
  ftp:zSzzSzftp.cs.wisc.eduzSzApproxzSztr21.pdf/
  deboor68least.pdf;  accessed 2008.07.22)

  Dierckx, Paul (1993), \emph{Curve and Surface Fitting with Splines},
  Springer.

  Jupp, D. L. B. (1975), \emph{Approximation to data by splines with
    free knots}, SIAM Journal on Numerical Analysis, 15: 328-343.
}
%\seealso{\code{\link{eval.penalty}}}
\examples{
data(titanium)
r <- curfit.free.knot(titanium$x2,
   titanium$y, g = 10, eps = 5e-4)
xyplot(r, show.knots = TRUE)

}
% docclass is function
\keyword{datasets}

