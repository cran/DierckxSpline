dierckx2fd <- function(object){
# Translate an object of class dierckx to class fd
##
## 1.  check class
##
  if(!inherits(object, 'dierckx'))
    stop("object is not of class 'dierckx', is ",
         class(object))
  objName <- deparse(substitute(object))
  {
    if(length(objName)>1)
      objName <- character(0)
    else
      if(nchar(objName)>33)
        objName <- substring(objName, 1, 33)
  }
  if(object$periodic)
    stop("object ", objName, " uses periodic B-splines.  ",
         "and dierckx2fd is programmed to translate only ",
         "B-splines with coincident boundary knots.")
##
## 2.  Create a basis
##
  rngval <- with(object, c(from, to))
  nKnots <- object$n
# length(dierckx$knots) = nest = estimated number of knots
# number actually used = dierckx$n
#  knots <- object$knots[1:n]
  Knots <- knots(object, interior=FALSE)
  k <- object$k
  nOrder <- k+1
  breaks <- Knots[nOrder:(nKnots-k)]
#
  xlab <- object$xlab
  if(!require(fda))
    stop("library(fda) required for function 'dierckx2fd'",
         ";  please install.")
#
  B.basis <- create.bspline.basis(rangeval=rngval, norder=nOrder,
                                breaks=breaks, names=xlab)
##
## 3.  Create fd object
##
  coef. <- coef(object)
#
  ylab <- object$ylab
  fdNms <- list(args=xlab, reps="reps 1", funs=ylab)
  fda::fd(coef=coef., basisobj=B.basis, fdnames=fdNms)
}

fd2dierckx <- function(object){
# Translate an object of class fd to class dierckx
##
## 1.  check class
##
  if(class(object) != 'fd')
      stop("object is not of class 'fd', is ", class(object))
##
## 2.  check k
##
  k <- with(object$basis, nbasis-length(params)-1)
  if(k<1)
    stop("DierckxSpline does NOT support splines of order 1 ",
         "(degree 0);  degree = ", k, ".  Aborting.")
  if(k>5)
    stop("DierckxSpline does NOT support splines of order more than 6 ",
         "(degree more than 5);  degree = ", k, ".  Aborting.")
##
## 3.  Let x = knots, y = values at knots
##
  rk4 <- 1/(4*k)
  knots0 <- with(object$basis, c(rangeval[1], params, rangeval[2]) )
  m0 <- length(knots0)
  x2 <- (knots0[-m0]+ outer(diff(knots0), seq(rk4, 1, rk4)))
  x <- sort(unique(c(knots0[1], x2)))
  m <- length(x)
  y <- eval.fd(object, x)
##
## 4.  Construct the dierckx version
##
#  curfit(x, y, k=k, s=0)
  knots <- c(rep(x[1], k), knots0, rep(x[m], k))
#  curfit(x, y, k=k, s=0, knots=knots)
#  curfit(x, y, k=k, n=length(knots), knots=knots)
  curfit(x, y, k=k, from=min(x), to=max(x), knots=knots)
}
