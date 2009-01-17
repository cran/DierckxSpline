\name{xyw.coords}
\alias{xyw.coords}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Extract fitting structures with weights 
}
\description{
  Extract arguments, eliminate duplicates in x, averaging corresponding
  y's, summing corresponding weights, and maintaining the dominant sign
  of convexity constraints.
}
\usage{
  xyw.coords(x, y = NULL, w = NULL, v = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A \code{data.frame}, \code{matrix}, or \code{numeric}
    vector. See details.}
  \item{y}{Optional numeric vector. See details.}
  \item{w}{Optional vector of weights}
  \item{v}{Convexity constraints. See details.}
  \item{\dots}{Optional arguments, currently ignored.}
}
\details{
  'x' and 'y' are first passed to \code{\link[grDevices]{xy.coords}} for
  initial parsing.  Then duplicate 'x' values are identified, and
  corresponding values of y, w and v are processed to average y's, sum
  w's, and use sign(sum(v's)).  If(missing(w)) w = 1.  If(missing(v)) v
  = 0.   
}
\value{
  A list with the following components:  
  \item{x}{unique of input x values, sorted}
  \item{y}{
    input y, arranged to match x, with values corresponding to duplicate
    x values replaced by their mean.
  }
  \item{w}{
    input w, arranged to match x, with values corresponding to duplicate
    x values replaced by their sum.
  }    
  \item{v}{
    input v, arranged to match x, with values corresponding to duplicate
    x values replaced by the sign of their sum.  
  }
  \item{xin}{input x values}
  \item{yin}{input y values}
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{
  \code{\link[grDevices]{xy.coords}}
  \code{\link{curfit}},
  \code{\link{concon}}
}
\examples{
x <- c(3, 1, 3+1e-7, 6, 3+5e-7, 5)
y <- c(3, 1, 2, 6, 4, 5) 
tst <- xyw.coords(x, y)
ans <- list(x = c(1, 3+2e-7, 5:6), y = c(1, 3, 5:6), w = c(1, 3, 1, 1),
            v = rep(0, 4), xin=x, yin=y) 
all.equal(tst, ans)
# TRUE
#all.equal(tst$x, c(1, 3, 5:6))
#[1] "Mean relative  difference: 6.666666e-08"
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
