fitted.dierckx <- function(object, ...) {
  s <- .Fortran("splev",
                knots = as.single(object$knots),
                n = as.integer(object$n),
                coef = as.single(object$coef),
                k = as.integer(object$k),
                x = as.single(object$x),
                sp = single(object$m),
                m = as.integer(object$m),
                ier = as.integer(object$ier))$sp
  as.double(s)
}
