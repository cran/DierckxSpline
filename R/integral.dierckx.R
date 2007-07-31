integral <- function(x, ...) {
  UseMethod("integral")
}

integral.dierckx <- function(x, from = NULL, to = NULL, ...) {
  from <- if(is.null(from)) min(x$knots) else max(from, min(x$knots))
  to <- if(is.null(to)) max(x$knots) else min(to, max(x$knots))
  n <- as.integer(x$n)
  int <- .Fortran("splint",
                  t = as.single(x$knots[seq(n)]),
                  n = as.integer(n),
                  c = as.single(x$coef[seq(n)]),
                  k = as.integer(x$k),
                  a = as.single(from),
                  b = as.single(to),
                  wrk = single(n),
                  aint = single(1))
  as.numeric(int$aint)
}

