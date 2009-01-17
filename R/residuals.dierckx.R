residuals.dierckx <- function(object, ...) {
  object$y - fitted(object)
}
