as.dierckx <- function(x){
  UseMethod('as.dierckx')
}

as.dierckx.fd <- function(x){
# Translate an object of class fd to class dierckx
##
## 1.  check class
##
  objName <- substring(deparse(substitute(x))[1], 1, 33)
#
  if(!inherits(x, 'fd')) 
    stop("'x' (", objName, ") is not of class 'fd', is ", class(x))
  basis <- x$basis
  if(is.null(basis))
    stop("'x' (", objName, ") does NOT have the required 'basis' ",
         "component.  Aborting.")   
  if(basis$type != 'bspline')
    stop("'x' (", objName, ") is not a bspline, has type = ", x$type) 
##
## 2.  check k
##  
  k <- with(basis, nbasis-length(params)-1)
  if(k<1)
    stop("DierckxSpline does NOT support splines of order 1 ",
         "(degree 0);  degree of ", objName, " = ", k, ".  Aborting.")  
  if(k>5)
    stop("DierckxSpline does NOT support splines of order more than 6 ",
         "(degree more than 5);  degree of ", objName, " = ", k,
         ".  Aborting.")  
##
## 3.  Let x = knots, y = values at knots 
##
  rk4 <- 1/(4*k) 
  knots0 <- with(basis, c(rangeval[1], params, rangeval[2]) )
  m0 <- length(knots0)
  x2 <- (knots0[-m0]+ outer(diff(knots0), seq(rk4, 1, rk4)))
  x. <- sort(unique(c(knots0[1], x2)))
  m <- length(x.)
  y <- eval.fd(x, x.)
##
## 4.  Construct the dierckx version 
##
#  curfit(x, y, k=k, s=0)
  knots <- c(rep(x.[1], k), knots0, rep(x.[m], k))
#  curfit(x, y, k=k, s=0, knots=knots) 
#  curfit(x, y, k=k, n=length(knots), knots=knots) 
  curfit(x., y, k=k, from=min(x.), to=max(x.), knots=knots)  
}
