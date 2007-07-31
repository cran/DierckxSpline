splineZeros <- function(object, maxiter=10){
##
## 1.  check clalss
##
  if(!("dierckx" %in% class(object)))
    stop("class(object) must be 'dierckx'.  Is not.  Instead, is ",
         class(object))
##
## 2.  Construct controlPolygon and evaluate spline
##     at the zeros of the control polygon
##
  cP <- controlPolygon(object)
  cP. <- predict(object, cP[, 1])
  obj. <- object
##
## 3.  while there are differences in sign, insert knots and iterate 
##  
  iter <- 0
  while(any(sign(cP[, 2]) != sign(cP.)) && (iter<=maxiter)){
    iter <- iter+1 
#    obj. <- insert.dierckx(obj.)
    obj. <- insert(obj.)
    cP <- controlPolygon(obj.)
    cP. <- predict(object, cP[, 1])
  }
##
## 4.  Use 'uniroot' to obtain the zeros in each interval
##     containing a sign change in the spline   
##
  n. <- length(cP.)
  cPs <- sign(cP.)
  signChg <- which(cPs[-1] != cPs[-n.])
  n.sc <- length(signChg)
  zeros <- array(NA, dim=c(n.sc, 4), dimnames = list(NULL,
       c("root", "f.root", "iter", "estim.prec") ) )
#  
  predDierckx <- function(x, object)predict.dierckx(object, x)
#  
  for(i in 1:n.sc){    
#    uni. <- uniroot(predict.dierckx, cP[i+0:1], object=object)
    uni. <- uniroot(predDierckx, cP[signChg[i]+0:1], object=object)
    zeros[i, ] <- unlist(uni.) 
  }
##
## 5.  Done
##
  zeros 
}
