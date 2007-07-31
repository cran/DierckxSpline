print.dierckx <- function(x, ...) {
  periodic <- if(x$periodic) "periodic " else ""
  label <- if(x$method == "ls") {
    "least squares"
  } else if(x$method == "ss") {
    "smoothing spline"
  } else {
    x$method
  }
  cat(periodic, label, " spline of degree ", x$k, "\n", sep = "")
  cat("smoothing factor s = ", format(x$s), "\n", sep = "")
  cat("number of interior knots g = ", x$g, "\n", sep = "")
  cat("position of interior knots\n")
  print(knots(x), ...)
  cat("b-spline coefficients\n")
  print(coef(x), ...)
  invisible()
}
