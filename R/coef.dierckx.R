coef.dierckx <- function(object, ...) {
##
## 1.  How many coef are active?
##
  nCoefActive <- with(object, g+k+1)
##
## 2.  Return only the active coefficients
##  
#  object$coef[abs(object$coef) > 0]
  object$coef[1:nCoefActive]
}
