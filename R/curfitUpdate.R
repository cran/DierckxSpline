curfitUpdate <- function(xyw, s=NULL, knots = NULL,
                         n = NULL, from = min(x), to = max(x),
                         k = 3, periodic = FALSE, ...) {
  eps <- .Machine$double.eps^0.5
  dots <- list(...)
##
## 1.  Update smoothing spline
##
  method <- 'ss'  
  iopt <- 1
##
## 2.  x, y, w
##  
  x <- xyw$x
  y <- xyw$y
  w <- xyw$w
  m <- length(x)
##
## 3.  Check for 'nest' in ...
##  
  {
    if("nest" %in% names(dots))
      nest <- dots$nest
    else
      nest <- (-1)
  }
  nest <- as.integer(max(nest, m + k + 1))
# curfit.f documentation:  'always large enough nest=m+k+1'
##
## 4.  Update details 
##      
  if(is.null(knots) || !is.numeric(knots) || length(knots) < 1)
    stop("invalid argument for 'knots'")
  n <- length(knots)
  if(n < 2*(k+1))
    stop("When knots are supplied, they must include k+1 = ",
         k+1, " replicates of the end knots.  Only ", n,
         " knots were provided, so this condition was violated.",
         "\n(When using 'knots.dierckx' for this, specify ",
         "interior=FALSE.)") 
  if(diff(range(knots[1:(k+1)]))>0)
    stop("When knots are supplied, they must include k+1 = ",
         k+1, " replicates of the end knots.  The first ",
         k+1, " knots were ", paste(knots[1:(k+1)], collapse=", "),
         ":  NOT identical.")
  if(diff(range(knots[(n-k):n]))>0) 
    stop("When knots are supplied, they must include k+1 = ",
         k+1, " replicates of the end knots.  The last ",
         k+1, " knots were ", paste(knots[(n-k):n], collapse=", "),
         ":  NOT identical.")      
  knots <- as.single(knots)
##
## 5.  Finish set-up
##  
  coef <- single(nest)
  lwrk <- if("lwrk" %in% names(dots)) dots$lwrk else -1
  lwrk <- as.integer(max(lwrk, 2 * (m * (k + 1) + nest * (7 + 3 * k))))
#    if(iopt == 1) {
#      if(any(!c("wrk", "iwrk") %in% names(dots))){
#        stop("Cannot update fit. Did you use 'update.dierckx'?")
  wrk <- as.single(c(dots$wrk[seq(n)], rep(0, lwrk - n)))
  iwrk <- as.integer(c(dots$iwrk[seq(n)], rep(0, nest - n)))
##
## 6.  Fit
##  
  val <- {
    if(periodic) {
    ## percur(iopt,m,x,y,w,k,s,nest,n,t,c,fp,wrk,lwrk,iwrk,ier)
      .Fortran("percur",
             iopt = as.integer(iopt),
             m = as.integer(m),
             x = as.single(x),
             y = as.single(y),
             w = as.single(w),
             k = k,
             s = as.single(s),
             nest = as.integer(nest),
             n = as.integer(n),
             knots = knots,
             coef = coef,
             fp = single(1),
             wrk = wrk,
             lwrk = lwrk,
             iwrk = iwrk,
             ier = integer(1))
    }
    else {
    ## curfit(iopt,m,x,y,w,xb,xe,k,s,nest,n,t,c,fp,wrk,lwrk,iwrk,ier)
# curfit.f documentation:  knots 'real array of dimension at least (nest)'
      Knots <- as.single(rep(knots, length=nest) )
      .Fortran("curfit",
             iopt = as.integer(iopt),
             m = as.integer(m),
             x = as.single(x),
             y = as.single(y),
             w = as.single(w),
             from = as.single(from),
             to = as.single(to),
             k = as.integer(k),
             s = as.single(s),
             nest = as.integer(nest),
             n = as.integer(n),
             knots = Knots,
             coef = as.single(coef),
             fp = single(1),
             wrk = wrk,
             lwrk = lwrk,
             iwrk = iwrk,
             ier = integer(1))
    }
  }
##
## 7.  Restore things to double precision so 'update' comparisons will work
##     o.w. we might delete the first and / or last observtions
##     because 'from' or 'to' picks up round-off in converting to
##     to and from single precision ... oops
##
  if((length(x)==length(val$x)) &&
     all(abs(val$x-x) < 2*eps))
    val$x <- x
#  
  if(is.null(val$from) || (abs(val$from-from) < 2*eps))
    val$from <- from
  if(is.null(val$to) || (abs(val$to-to) < 2*eps)) 
    val$to <- to   
##
## 8.  Decode 'ier' error code
##  
  val$message <- switch(as.character(val$ier),
      "0" = character(0),
     "-1" = "Spline returned is an interpolating spline.",
     "-2" = {
       fmt1 <- paste("Spline returned is the weighted",
                     "least-squares polynomial of degree %d.")
       msg1 <- sprintf(fmt1, k)
       msg2 <- sprintf("Upper bound on 's' is %f.", val$fp)
       paste(msg1, msg2)
     },
      "1" = {
        paste("The required storage exceeds the available",
                       "storage space specified by 'nest'.")
      },
      "2" = {
        paste("A theoretically impossible result was found;  ",
              "is 's' too small?")
      },
      "3" = "The maximum number of iterations (20) has been  reached.",
      {
        msg <- "" 
        if(val$iopt != (-1))
          msg <- sprintf("Illegal option %d.", val$iopt)
        if(val$k < 1 || val$k > 5)
          msg <- sprintf("%s Illegal 'k' (%d).", msg, val$k)
        if(length(val$x) <= val$k)
          msg <- sprintf("%s Length 'x' (%d) must be greater than 'k' (%d).",
                         msg, m, val$k)
        if(val$nest < 2 * val$k + 2)
          msg <- sprintf("%s Illegal value of 'nest' (%d).",
                         msg, val$nest)
        if(val$lwrk < with(val, (k + 1) * m + nest * (7 + 3 * k)))
          msg <- sprintf("%s Illegal value of 'lwrk' (%d).",
                         msg, val$lwrk)
        if(!all(val$w > 0))
          msg <- sprintf("%s Some weights nonpositive.", msg)
#
        n <- length(knots)
        if(n < 2 * k + 2 || n > min(val$nest, m + k + 1))
          msg <- sprintf("%s Illegal number of knots (%d).",
                         msg, if(is.null(val$g)) 0 else val$g)
        chknots <- ((val$knots[k + 2] < min(x)) ||
                    (val$knots[n - k - 1] > max(x)) ||
                    all(x %in% val$knots)) 
        if(chknots)
          msg <- sprintf("%s Illegal knot selection.", msg)
      }
                        )
  if(val$ier > 0) stop(val$message)
##
## 10.  Clean up
##  
  val$g <- with(val, length(knots[knots > min(x) & knots < max(x)]))
  sing <- names(unlist(sapply(val, attr, "Csingle")))
  val[sing] <- lapply(val[sing], as.double)
  val$method <- method
  val$periodic <- periodic
  val$routine <- "curfit.default"
  val$xlab <- xyw$xlab
  val$ylab <- xyw$ylab
  if(length(xyw$xin) > m) {
    val$x <- xyw$xin
    val$y <- xyw$yin
    val$sp <- predict.dierckx(val, newx = xyw$xin)
  } else {
    val$sp <- fitted(val)
  }
  class(val) <- "dierckx"
  val
}
