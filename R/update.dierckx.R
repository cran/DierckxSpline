update.dierckx <- function(object, knots, k, s, ...) {
  if(!missing(knots))
    object$knots <- knots    
  if(!missing(k))
    object$k <- k
  if(!missing(s))
    object$s <- s
  do.call(object$routine, object)
}
