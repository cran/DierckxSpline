\name{panel.dierckx}
\alias{panel.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Panel function for xyplot.dierckx
}
\description{
  This is the default panel function for 'xyplot.dierckx'.
}
\usage{
panel.dierckx(x, y, newx, newy, knots = NULL, knots.y = NULL, lty = 2,
              knot.cex = 1.5, knot.col = "red", knot.fill = "lightgray",
              ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x, y}{ points to be plotted }
  \item{newx, newy}{ line to be drawn }
  \item{knots}{
    a vector of x-axis position to mark as interior 'knots' of the
    spline.
  }
  \item{knots.y}{
    a vector of y-axis positions corresponding to 'knots'.
  }
  \item{lty}{
    line type for 'panel.xyplot'.
  }
  \item{knot.cex}{
    character expansion for plotted knots.
  }
  \item{knot.col}{
    color to use when plotting the knots
  }
  \item{knot.fill}{
    'fill' argument passed to 'lpoints' when plotting the knots;  see
    \code{\line{lpoints}}.
  }
  \item{\dots}{
    other graphics parameters passed to \code{\line{lpoints}} and
    \code{\line{panel.xyplot}}.
  }
}
\details{
  Creates a scatterplot of 'x' and 'y' with a line plot of 'newx' and
  'newy', optionally marking the knots at 'knots' and 'knots.y'.
}
%\value{}
\references{
  Dierckx, P. (1993) \emph{Curve and Surface Fitting with Splines},
  Oxford Science Publications.
}
\author{Sundar Dorai-Raj and Spencer Graves}
\seealso{
  \code{\link{concon}},
  \code{\link[stats]{spline}},
  \code{\link[stats]{smooth.spline}}}
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{aplot}
