\name{dierckx2fd}
\alias{dierckx2fd}
\alias{fd2dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Translate dierckx and fd objects}
\description{
  Translate a non-periodic object of class dierckx into an object of
  class fd (functional data, in the fda package), and vice versa.  The
  'translations' are, however, imperfect, in that many components of
  each are not present in the other.   
}
\usage{
dierckx2fd(object)
fd2dierckx(object) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
    an object of class dierckx (for 'dierckx2fd') or fd (for
    'fd2dierckx') to be translated into the other class.
  }
}
\details{
  The 'translations' do not translate everything.

  \item{dierckx2fd}{
    The 'fda' package (as of version 1.2.2) supports B-splines with
    coincident boundary knots.  It recommends Fourier bases for periodic
    phenomena and does not supporb B-splines with periodic boundary
    knots.  Accordingly, 'dierckx2fd' currently stops with an error
    message if object[["periodic"]] is TRUE.  
    
    \itemize{
      \item{x}{lost.  Restored from the knots.}
      \item{y}{
	lost.  Restored from spline predictions at the restored values
	of 'x'.  
      }
      \item{w}{lost.  Restored as rep(1, length(x)).}
      \item{from, to}{fd[["basis"]][["rangeval"]] }
      \item{k}{
	coded indirectly as fd[["basis"]][["nbasis"]] -
	length(fd[["basis"]][["params"]]) - 1.  
      }
      \item{s}{lost, restored as 0.}
      \item{nest}{lost, restored as length(x) + k + 1}
      \item{n}{
	coded indirectly as 2*fd[["basis"]][["nbasis"]] -
	length(fd[["basis"]][["params"]]).
      }
      \item{knots}{
	The end knots are stored (unreplicated) in
	fd[["basis"]][["rangeval"]], while the interior knots are stored
	in fd[["basis"]][["params"]].
      }
      \item{fp}{lost.  Restored as 0.}
      \item{wrk, lwrk, iwrk}{
	lost.  Restore by refitting to the knots.  
      }
      \item{ier}{lost.  Restored as 0.}
      \item{message}{lost.  Restored as character(0).}
      \item{g}{stored indirectly as length(fd[["basis"]][["params"]]).}
      \item{method}{lost.  Restored as "ss".}
      \item{periodic}{
	'dierckx2fd' only translates 'dierckx' objects
	with coincident boundary knots.  Therefore, 'periodic' is
	restored as FALSE.
      } 
      \item{routine}{lost.  Restored as 'curfit.default'.}
      \item{xlab}{fd[["fdnames"]][["args"]]}
      \item{ylab}{fd[["fdnames"]][["funs"]]}
    }
  }
   
}
\value{
  'dierckx2fd' converts an object of class 'dierckx' into one of class 
  'fd'.

  'fd2dierckx' converts an object of class 'fd' into one of class
  'dierckx'.  
  An object of the other class.  
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.

  Ramsay, James O., and Silverman, Bernard W. (2006), \emph{Functional
    Data Analysis, 2nd ed.}, Springer, New York. 

  Ramsay, James O., and Silverman, Bernard W. (2002), \emph{Applied
    Functional Data Analysis}, Springer, New York. 
}
\author{Spencer Graves}
\seealso{
  \code{\link{curfit}}
  \code{\link[fda]{fd}}
}  
\examples{
x <- 0:24
y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
       13.4,12.8,13.1,13.0,14.0,13.0,13.5,
       10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)
curfit.xy <- curfit(x, y, s=0)

library(fda)
curfit.fd <- dierckx2fd(curfit.xy)
plot(curfit.fd) # as an 'fd' object 
points(x, y) # Curve goes through the points.  

x. <- seq(0, 24, length=241)
pred.y <- predict(curfit.xy, x.) 
lines(x., pred.y, lty="dashed", lwd=3, col="blue")
# dierckx and fd objects match.

curfit2 <- fd2dierckx(curfit.fd)
pred.y2 <- predict(curfit2, x.)
sum(abs(pred.y-pred.y2))/(sum(abs(pred.y)+abs(pred.y2))/2)
# 2.7e-7 
all.equal(knots(curfit.xy, FALSE), knots(curfit2, FALSE))
# TRUE 
all.equal(coef(curfit.xy), coef(curfit2)) 
# "Mean relative  difference: 6.026638e-07"

preserved <- c("from", "to", "n", "g", "periodic", "xlim","ylim")
all.equal(curfit.xy[preserved], curfit2[preserved])
# TRUE 
# Other components are NOT preserved in translation
# and so can NOT be restored.

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{manip}
