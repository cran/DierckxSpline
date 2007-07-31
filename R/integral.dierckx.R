#integral <- function(x, ...) {
#  UseMethod("integral")
#}

integral.dierckx <- function(expr, from = NULL, to = NULL, ...) {
  from <- {
    if(is.null(from)) min(expr$knots)
    else max(from, min(expr$knots))
  }
  to <- { 
    if(is.null(to)) max(expr$knots)
    else min(to, max(expr$knots))
  }
  n <- as.integer(expr$n)
  int <- .Fortran("splint",
                  t = as.single(expr$knots[seq(n)]),
                  n = as.integer(n),
                  c = as.single(expr$coef[seq(n)]),
                  k = as.integer(expr$k),
                  a = as.single(from),
                  b = as.single(to),
                  wrk = single(n),
                  aint = single(1))
  as.numeric(int$aint)
}

