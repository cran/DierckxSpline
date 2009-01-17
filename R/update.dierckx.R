update.dierckx <- function(object, knots, k, s, ...) {
  if(!missing(knots)){
    if(is.numeric(knots))
      object$knots <- knots
    else
      object$knots <- knots(knots, interior=FALSE)
  }
  if(!missing(k)) object$k <- k
  if(!missing(s)) object$s <- s
#  
  do.call(object$routine, object)
}
