deviance.dierckx <- function(object, scale = FALSE, ...) {
  df <- if(scale) with(object, length(x) - g - k - 1) else 1
  object$fp/df
}
