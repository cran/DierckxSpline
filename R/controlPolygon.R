controlPolygon <- function(object) {
# Dierckx, p. 20
  switch(class(object),
     "dierckx" = {       
       Knots <- knots(object, FALSE)
       Order <- (object$k+1)
       Coef <- coef(object)
     }, 
     "fd" = {
       Order = with(object$basis, nbasis - length(params))
       Coef <- as.vector(object$coefs)
       Knots = with(object$basis, c(rep(rangeval[1], Order),
         params, rep(rangeval[2], Order))) 
     },
         stop("class(object) must be either 'dierckx' or 'fd'")
         )
#
  n <- length(Knots) 
  g <- n-2*Order 
#  
  nCP <- length(Coef) 
  knotsCP <- rep(NA, nCP)
  ik <- 1:(Order-1) 
  for(i in 1:nCP){
    knotsCP[i] <- mean(Knots[i+ik])
  }
  cbind(breakPoint=knotsCP, coef=Coef) 
}
