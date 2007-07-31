\name{update.dierckx}
\alias{update.dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Update method for object of class 'dierckx'.
}
\description{
  Update a fit using any of several different functions that produce an
  object of class 'dierckx'.
}
\usage{
  \method{update}{dierckx}(object, knots, k, s, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ an object of class 'dierckx' }
  \item{knots}{
    either a numeric vector or an object from which knots(knots,
    interior=FALSE) will produce the desired numeric vector.
  }
  \item{k}{
    a positive integer giving the degree of the spline = one more than
    the order of the polynomial segments.  Valid options for \code{k}
    are 1 to 5, inclusively.
  }
  \item{s}{
    a nonnegative number or NULL.
  }
  \item{\dots}{
    Currently ignored.

    Additional arguments used only in \code{update.curfit}. Otherwise,
    ignored.
  }
}
%\details{}
\value{
  An object as produced by the function named in 'object[["routine"]]'.
}
\references{
Dierckx, P. (1993) \emph{Curve and Surface Fitting with Splines}, Oxford
Science Publications.
}
\author{Sundar Dorai-Raj and Spencer Graves}
\seealso{
  \code{\link{concon}}
  \code{\link[stats]{spline}}
  \code{\link[stats]{smooth.spline}}
}
\examples{
x <- 0:24
y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
       13.4,12.8,13.1,13.0,14.0,13.0,13.5,
       10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)

#fitLS0 <- curfit(x, y)
#fitSS0 <- curfit(x, y, s=0)

ks <- c(3, 5, 2)
kk <- length(ks)
z <- vector("list", kk)
names(z) <- ks
for(i in 1:kk) {
  k <- ks[i]
  z1 <- curfit(x, y, s = 1000, k = k)
  z2 <- update(z1, s = 60)
  z3 <- update(z2, s = 10)
  z4 <- update(z3, s = 30)
  z5 <- curfit(x, y, s = 30, k = k)
  z6 <- update(z5, s = 0)
  knots <- c(rep(0, k + 1), seq(3, 21, 3), rep(24, k + 1))
  z7 <- curfit(x, y, s = 30, knots = knots, k = k)
  z[[i]] <- list(z1, z2, z3, z4, z5, z6, z7)
}

p <- unlist(z, recursive = FALSE)
n <- sapply(lapply(p, knots), length)
s <- sapply(p, "[[", "s")
i <- sapply(p, "[[", "iopt")
m <- ifelse(i == -1, "ls", ifelse(i == 0, "ss", "ss1"))
k <- sprintf("k = \%d", sapply(p, "[[", "k"))
g <- sprintf("\%s(s=\%d)", m, s, i)
sp <- data.frame(x = rep(x, times = length(p)),
     y = rep(y, times = length(p)), z = unlist(lapply(p, fitted)),
     k = factor(rep(k, each = length(x))), g = rep(g, each = length(x)))

library(lattice)
xyplot(z ~ x | k, data = sp, groups = g,
   panel = function(x, y, subscripts, groups, obs, ...) {
     panel.superpose(x, y, subscripts, groups, lwd = 3, type = "l", ...)
     x <- unique(x)
     y <- unique(obs)
     panel.xyplot(x, obs, pch = 16, cex = 1.2, col = "darkblue")
   },
   auto.key = list(space = "right", points = FALSE, lines = TRUE),
   obs = sp[["y"]])

## periodic spline
set.seed(42)
n <- 100
r <- 1:n
x <- 0.01 * (r - 1)
e <- rnorm(n, 0, 0.1)
w <- rep(1/sd(e), n + 1)
y <- cos(2 * pi * x) + 0.25 * sin(8 * pi * x) + e
x <- c(x, 1)
y <- c(y, y[1])
kn <- seq(0.01, 0.99, length = 12)
f1 <- percur(x, y, w = w, s = 90, k = 5)

library(lattice)
top <- xyplot(y ~ x,
              panel = function(x, y, ...) {
                panel.abline(v = knots(f1), lty = 2, lwd = 3, col = "gray")
                panel.xyplot(x, y, pch = 16, col = "#800000", cex = 1.2)
                panel.xyplot(x, fitted(f1), type = "l", lwd = 3, col = "#000080")
              },
              par.settings = list(layout.widths = list(left.padding = 0, right.padding = 0)),
              scales = list(cex = 1.2),
              xlab = "", ylab = "")
newx <- seq(-2, 2, 0.01)
newy <- predict(f1, newx)
bot <- xyplot(newy ~ newx, type = "l",
              panel = function(...) {
                panel.abline(v = -2:2, lty = 2, col = "salmon", lwd = 3)
                panel.xyplot(...)
              },
              col = "#000080", lwd = 3,
              par.settings = list(layout.widths = list(left.padding = 0, right.padding = 0)),
              scales = list(cex = 1.2),
              xlab = "", ylab = "")
print(top, c(0, 0.2, 1, 1))
print(bot, c(0.008, 0, 0.992, 0.25), newpage = FALSE)

## example borrowed from ?smooth.spline
plot(cars[["speed"]], cars[["dist"]],
     main = "data(cars)  &  smoothing splines",
     xlab = "SPEED", ylab = "DISTANCE",
     cex.lab = 1.2, cex.axis = 1.2,
     cex.main = 2, cex = 1.5, col = "blue")
## This example has duplicate points, so avoid cv=TRUE
cars.spl.0 <- smooth.spline(cars[["speed"]], cars[["dist"]])
cars.spl.1 <- smooth.spline(cars[["speed"]], cars[["dist"]], df = 10)
cars.spl.2 <- curfit(cars[["speed"]], cars[["dist"]], s = 5e3)
newx <- seq(min(cars[["speed"]]), max(cars[["speed"]]), len = 200)
lines(predict(cars.spl.0, newx), col = "blue", lwd = 3, lty = 2)
lines(predict(cars.spl.1, newx), lty="dashed", col = "red", lwd = 3)
lines(newx, predict(cars.spl.2, newx), lty="dotted", lwd = 3)
legend(5, 120, c(paste("smooth.spline( * , df = ",
             round(cars.spl.0[["df"]], 1), ")", sep = ""),
                 "smooth.spline( * , df = 10)", "curfit( * , s = 5e3)"),
       col = c("blue", "red", "black"),
       lty = c("solid", "dashed", "dotted"), lwd = 3,
       bg = 'bisque', cex = 1.5)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{optimize}
