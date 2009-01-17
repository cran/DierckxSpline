predict.dierckx <- function(object, newdata, ...) {
  if(missing(newdata) || is.null(newdata))return(fitted(object))
  if(!is.numeric(newdata) || length(newdata) == 0)
    stop("Invalid value for argument 'newdata'")
  if(!is.null(object$periodic) && object$periodic) {
    period <- range(object$x)
    xb <- period[1]
    xe <- period[2]
    if(any(newdata < xb | newdata > xe)) {
      rn <- range(newdata) %/% diff(period)
      br <- if(rn[1] == rn[2]) {
        c(rn[1], rn[1] + diff(period))
      } else {
        seq(rn[1], rn[2], diff(period))
      }
      ct <- cut(newdata, br, include.lowest = TRUE)
      newdata <- newdata - br[ct]
    }
  }
  o <- order(newdata)
  m <- length(newdata)
  sp <- .Fortran("splev",
                 knots = as.single(object$knots),
                 n = as.integer(object$n),
                 coef = as.single(object$coef),
                 k = as.integer(object$k),
                 x = as.single(newdata[o]),
                 sp = single(m),
                 m = as.integer(m),
                 ier = as.integer(object$ier))$sp
  sp <- as.numeric(sp)
  sp <- sp[order(o)]
  sp
}
