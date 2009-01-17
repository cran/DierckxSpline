deriv.dierckx <- function(expr, at = NULL, order = 1, ...) {
  if(is.null(at)) at <- expr$x
  if(length(at) == 0)
    stop("length of 'at' is 0")
  if(order > expr$k || order < 0)
    stop("'order' must be between 0 and ", expr$k, ", inclusively")
  m <- length(at)
  der <- .Fortran("splder",
                  knots = as.single(expr$knots),
                  n = as.integer(expr$n),
                  c = as.single(expr$coef),
                  k = as.integer(expr$k),
                  nu = as.integer(order),
                  x = as.single(at),
                  y = single(m),
                  m = as.integer(m),
                  wrk = as.single(expr$wrk),
                  ier = integer(1))
  if(der$ier != 0)
    stop("subroutine 'splder' returned an error")
  as.numeric(der$y)  
}

#x <- seq(.05, .05 * 7, len = 7)
#y <- c(0, 0.05, 0.15, 0.30, 0.50, 0.75, 1)
#s <- curfit(x, y, knots = c(.1, .3, .4, 1), k = 1)
#deriv(s, order = 1)
#plot(x, y)
#xyplot(s)
#plot(x, deriv(s))
