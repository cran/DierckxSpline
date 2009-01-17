\name{curfit.free.knot}
\alias{curfit.free.knot}
\title{free-knot splines}
\description{
  Least squares splines with variable knots.  
}
\usage{
curfit.free.knot(x, y, w=NULL, k = 3, g = 10, eps = 0.5e-3,
                 prior = NULL, fixed = NULL, trace=1, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A \code{data.frame}, \code{matrix}, or \code{numeric}
    vector.}
  \item{y}{Optional numeric vector.}
  \item{w}{Observation weights.}
  \item{k}{
    degree of the spline;  k=3 for cubic spline.
  }
  \item{g}{
    integer vector specifying the number(s) of knots to try.  
    
    This is ignored if 'prior' is provided.

    If(length(g) == 1) g = 1:g.  If(length(g)>1) g = seq(min(g),
    max(g)).  
  }
  \item{eps}{
    weight on the reciprocal differences between successive knots:

    \deqn{
    penalty = eps*(diff(range(x))/(length(knots)+1)^2) *
    sigma0 * sum(1/diff(unique(knots)))
    }

  }
  \item{prior}{initial values for the free knots}
  \item{fixed}{locations of fixed knots}
  \item{trace}{
    a number indicating the trace level.  If 'g' is parsed as a vector,
    then with trace > 0, after a model for each g[i] is fit, the
    algorithm reports the number of knots, the variance of the
    residuals, and the z-score for the lag 1 autocorrelation of
    residuals. 

    For g[i] > 1, 'optim' is called with control=list(trace=trace-1). 
  }
  \item{\dots}{
    Additional arguments used by \code{curfit}.
  }
}
\details{
  1.  If(!is.null(prior)) fit only a model with that number if free
  knots.

  2.  Otherwise, decode 'g' and fit one model for each level of 'g'.

  3.  Return the first model with a negative lag 1 autocorrelation, if
  any.  Otherwise, return the last model fit.  
}
\value{
  An object of class \code{dierckx} with the following components:

  %???? anything more than returned by curfit?  

  
  \item{iopt}{method used}
  \item{m}{length of 'x'}
  \item{x}{abscissa values}
  \item{y}{ordinate values}
  \item{w}{input weights}
  \item{from}{input \code{from} value}
  \item{to}{input \code{to} value}
  \item{k}{ degree of the spline } 
  \item{s}{input smoothing parameter}
  \item{nest}{Estimated number of knots}
  \item{n}{Actual number of knots}
  \item{knots}{Knot locations.}
  \item{coef}{b-Spline coefficients. Use \code{coef.dierckx} to extract.}
  \item{fp}{
    sum of squares residuals. Use \code{deviance.dierckx} to
    extract.
  }
  \item{wrk}{
    Work space. Do NOT modify before call to \code{update.dierckx}
  }
  \item{lwrk}{
    Length of \code{wrk}. Do NOT modify before call to
    \code{update.dierckx}
  }
  \item{iwrk}{
    Integer work space. Do NOT modify before call to
    \code{update.dierckx}
  }
  \item{ier}{Error code. Should always be zero.}
  \item{message}{ convergence message or character(0) } 
  \item{g}{Number of interior knots}
  \item{method}{input \code{method} value, e.g, 'ls' for least squares}
  \item{periodic}{logical:  TRUE for a periodic spline} 
  \item{routine}{Always 'curfit.default'}
  \item{xlab}{ character x axis label for a plot}
  \item{ylab}{ character y axis label for a plot}
  \item{fits}{
    This component is only present if(is.null(prior)).  In that case it
    is a list with other objects of class 'dierckx' with attributes
    'iopt', 'm', 'x', 'y', 'w', 'from', 'to', 'k', 's', 'nest', 'n',
    'knots', 'coef', 'fp', 'wrk', 'lwrk', 'iwrk', 'ier', 'message', 'g',
    'method', 'periodic', 'routine', 'xlab', 'ylab', as just described,
    one for each value of 'g' tested.
  }
  \item{summary}{ a data.frame with the following columns:

    \itemize{
      \item{g}{vector of the values of 'g' tested}
      \item{sigma}{
	variance of the residuals = (sum of squares of residuals) /
	(degrees of freedom)  	
      }
      \item{T}{
	z-score for the lag 1 autocorrelation of residuals =
	sqrt(length(x)-1) * (lag 1 autocorrelation of the residuals).  
      }
    }
  }
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{
  \code{\link{curfit}},
  \code{\link{concon}},
  \code{\link[stats]{spline}},
  \code{\link[stats]{smooth.spline}}}
\examples{
data(titanium)
titan10 <- with(titanium, curfit.free.knot(x, y))
#titan10.1 <- with(titanium, curfit.free.knot(x, y, k=1))
#titan10.1 <- with(titanium, curfit.free.knot(x, y, k=1, g=8, trace=1.1))
#titan10.1 <- with(titanium, curfit.free.knot(x, y, k=1,g=7:8, trace=1.1))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{optimize}
