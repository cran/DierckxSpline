\name{concon}
\alias{concon}
\alias{concon.default}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Curve fitting with convexity constraints}
\description{
  General curve fitting with splines with convexity constraints.
  Wrapper for the Fortran function CONCON.
}
\usage{
concon(x, ...)
\method{concon}{default}(x, y = NULL, w = NULL, v = 0, s = 0, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{A \code{data.frame}, \code{matrix}, or \code{numeric}
    vector. See details.}
  \item{y}{Optional numeric vector. See details.}
  \item{w}{Optional vector of weights}
  \item{v}{Convexity constraints. See details.}
  \item{s}{Smoothing parameter}
  \item{\dots}{Additional arguments used only in
    \code{update.concon}. Otherwise, ignored.}
}
\details{
  As with \code{\link[stats]{smooth.spline}}, the \code{x} vector should
  contain at least four distinct values. \emph{Distinct} here means
  ``distinct after rounding to 6 significant digits'', i.e., \code{x}
  will be transformed to \code{unique(sort(signif(x, 6)))}, and
  \code{y}, \code{w}, and \code{v} are pooled accordingly.

  For the default method, arguments \code{x} and \code{y} are supplied
  to \code{\link{xy.coords}} to determine abscissa and ordinate
  values. The actual function used is \code{DierckxSpline:::xyw.coords}
  which is not exported in the \code{NAMESPACE}.

  \code{concon} determines a smooth cubic spline approximation
  \code{s(x)}. See chapters 1 and 3 in the reference for definition of
  symbols.

  The vector \code{v} should be the same length as \code{x}. \code{v[i]}
  must be set to \code{1} if \code{s(x)} must be locally concave at \code{x[i]},
  to \code{-1} if \code{s(x)} must be locally convex at \code{x[i]} and to \code{0}
  if no convexity constraint is imposed at \code{x[i]}. If all \code{v}
  are 0 (no consraints) an error is thrown suggesting the use of
  \code{\link{curfit}} instead.
}
\value{
  An object of class \code{dierckx} with the following components:
  \item{iopt}{method used}
  \item{m}{length of \code{x}}
  \item{x}{abscissa values}
  \item{y}{ordinate values}
  \item{w}{input weights}
  \item{s}{input smoothing parameter}
  \item{nest}{Estimated number of knots}
  \item{n}{Actual number of knots}
  \item{knots}{Knot locations. Do NOT modify before call to
    \code{update.dierckx}}
  \item{g}{Number of interior knots}
  \item{coef}{b-Spline coefficients. Use \code{coef.dierckx} to extract.}
  \item{fp}{sum of squares residuals. Use \code{deviance.dierckx} to
    extract.}
  \item{wrk}{Work space. Do NOT modify before call to
    \code{update.dierckx}}
  \item{lwrk}{Length of \code{wrk}. Do NOT modify before call to
    \code{update.dierckx}}
  \item{iwrk}{Integer work space. Do NOT modify before call to
    \code{update.dierckx}}
  \item{kwrk}{Length of \code{iwrk}. Do NOT modify before call to
    \code{update.dierckx}}
  \item{bind}{Indicates the knots where \code{s''(x)=0}. Do NOT modify before call to
    \code{update.dierckx}}
  \item{sx}{Indicates the knots where \code{s''(x)=0}. Do NOT modify before call to
    \code{update.dierckx}}
  \item{ier}{Error code. Should always be zero.}
  \item{method}{input \code{method} value}
  \item{k}{Always 3 (cubic spline)}
  \item{periodic}{Always \code{FALSE}}
  \item{routine}{Always 'concon.default'}
  \item{xlab}{
    The x-label determined from \code{deparse(substitute(x)).}
  }
  \item{ylab}{
    The y-label determined from \code{deparse(substitute(y)).}
  }
}
\references{
Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj}
\seealso{\code{\link{curfit}}, \code{\link[stats]{spline}}, \code{\link[stats]{smooth.spline}}}
\examples{
data(moisture)
\dontrun{
f1 <- with(moisture, concon(x, y, w, v, s = 0.2))
f2 <- update(f1, s = 0.04)
f3 <- update(f1, s = 0.0002)
g1 <- with(moisture, curfit(x, y, w, knots = knots(f1, interior=FALSE)))
#must include end knots, via interior = FALSE
g2 <- update(g1, knots = knots(f2, FALSE))
g3 <- update(g1, knots = knots(f3, FALSE))

newx <- with(moisture, seq(min(x), max(x), length = 100))
method <- c("Convexity Constrained", "Unconstrained Least Squares")
group <- c("0 interior knots", "1 interior knot", "3 interior knots")
out <- data.frame(x = rep(newx, times = 6),
         y = c(predict(f1, newx), predict(f2, newx),
               predict(f3, newx), predict(g1, newx),
               predict(g2, newx), predict(g3, newx)),
         group = rep(group, each = 100, times = 2),
         method = rep(method, each = 3 * 100))

library(lattice)
xyplot(y ~ x | method, out, groups = group, panel = function(...) {
         panel.superpose(...)
         panel.xyplot(moisture$x, moisture$y,
                      col = "#800000", pch = 16, cex = 1.2)
       },
       xlim = c(-1, 11), xlab = "", ylab = "", layout = c(1, 2),
       as.table = TRUE, scales = list(cex = 1.2),
       par.strip.text = list(cex = 1.5), type = "l", lwd = 3,
       key = list(space = "top", cex = 1.2, columns = 3,
         text = list(levels(out$group)),
         lines = list(lwd = 3, col = trellis.par.get("superpose.line")$col[1:3])))
}}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{optimize}
