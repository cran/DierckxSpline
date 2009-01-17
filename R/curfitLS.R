curfitLS <- function(xyw, s=NULL, knots = NULL, n = NULL, from, to,
                     k = 3, periodic = FALSE, ...) {
  eps <- .Machine$double.eps^0.5
#  dots <- list(...)
##
## 1.  Least squares fit
##
  method = 'ls' 
  iopt <-  (-1)
  s <- 0 
##
## 2.  x, y, w
##
  x <- xyw$x
  y <- xyw$y
  w <- xyw$w
  m <- length(x)   
##
## 3.  Least squares spline    
##
#  if(missing(n) && is.null(knots)){
#    stop("Either 's' (level of smoothing) or one of ",
#         "'knots' or 'n' (number of knots) must be supplied;  ",
#         "none were.")
  {
    if(is.null(knots)){
      if(is.null(n))
        stop("Either knots or 'n' must be provided for a least",
             " squares spline.") 
      else{
        if(n < 2*(k+1))
          stop("When knots are supplied, they must include k+1 = ",
               k+1, " replicates of the end knots.  Only ", n,
               " knots were provided, so this condition was violated.",
               "\n(When using 'knots.dierckx' for this, specify ",
               "interior=FALSE.)") 
        if(n > (m+k+1))
          stop("The number of knots, n = ", n,
               ", minus the order of the spline (", k+1,
               " for a spline of degree k = ", k,
               ") must not exceed the number of distinct ",
               "x values, which is ", m) 
        g2 <- n-2*k
        knots <- c(rep(from, k), seq(from, to, length=g2),
                   rep(to, k) )
      }
    }
    else {
#    xb <- min(x)
#  from <- min(x) ; per input arguments 
#    xe <- max(x)
#  to <- max(x) ; per input arguments 
#  if(!is.null(knots)) {
      if(!is.numeric(knots))
        stop("'knots' must be numeric;  is ", class(knots))
#     knots <- sort(unique(knots))
      knots <- sort(knots)
      if(!is.null(n) && (n != length(knots))) 
        stop("n = ", n, " != length(knots) = ", length(knots),) 
      n <- length(knots)
#      knots <- knots[(knots > xb + eps) & (knots < xe - eps)]
      intknots <- knots[(knots > from + eps) & (knots < to - eps)]
      g <- length(intknots)
      {
        if(periodic) {
          if(g >= k)
#         Standard periodic boundary knots
#         per Dierckx (1993, p. 11)           
#          knots <- c(knots[rev(g + 1 - (1:k))] - xe + xb,
#                     xb, knots, xe, knots[1:k] + xe - xb)
          knots <- c(intknots[rev(g + 1 - (1:k))] - to + from,
                     from, intknots, to, intknots[1:k] + to - from)
          else 
            stop("must have at least ", k,
                 " interior knots for periodic splines")
        } # end if(g>=k) 
        else # end if(periodic) 
#       Replicate the end knots for coincident boundary knots
#       per Dierckx (1993, p. 11) 
          knots <- c(rep(from, k + 1), intknots, rep(to, k + 1))
      }
    } # end if(!is.null(knots))
#  else {
#       Use n         
#    if(n < 0) stop("'n' must be greater than 0")
#        interior <- seq(xb, xe, length = max(0, n - 2 * k))
#    interior <- seq(from, to, length = max(0, n - 2 * k))
#        knots <- c(rep(xb, k), interior, rep(xe, k))
#    knots <- c(rep(from, k), interior, rep(to, k))
#  }
  }
  knots <- as.single(knots)
  n <- length(knots)
##
## 4.  Finish set-up
##  
##
## .  Check for 'nest' in dots
##
#************* IS THE NEEDED?
#  {
#    if("nest" %in% names(dots))
#      nest <- dots$nest
#    else
#      nest <- (-1)
#  }
#  nest <- as.integer(max(nest, m + k + 1))
  nest <- as.integer(max(n, 2*k+3, m + k + 1))
# curfit.f documentation:  'always large enough nest=m+k+1'
  coef <- single(nest)
  lwrk <- as.integer(max(-1, 2 * (m * (k + 1) + nest * (7 + 3 * k))))
  wrk <- single(lwrk)
  iwrk <- integer(nest)
##
## 5.  Fit
##  
  Knots <- as.single(rep(knots, length=nest) )
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
             knots = Knots,
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
## 6.  Restore things to double precision so 'update' comparisons will work
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
## 7.  Decode 'ier' error code
##
  msg <- NULL 
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
     "-3" = {
        if(val$iopt != (-1)) 
          msg <- sprintf("Illegal option %d for a least squares spline.",
                         val$iopt)
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
        msg
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
        msg <- paste("ier =", val$ier, ":  ")
#        if(val$iopt > 1 || val$iopt < -1)
        if(val$iopt != (-1)) 
          msg <- sprintf("Illegal option %d for a least squares spline.",
                         val$iopt)
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
        msg
      }                        
                        )
#  if(val$ier > 0){
#    if(val$ier>3)
#      cat("BUG IN curfitLS:  Violation of Fortran requirements.\n",
#          "iopt =", iopt, ';  k =', k, ';m =', m, ';  n =', n,
#          ';  nest =', nest, ';  lwrk =', lwrk, ';  s =', s, 
#          '\nrange(w) =', range(w), '\n  knots =', knots,
#          '\nrange(x) =', range(x), ';  range(diff(x)) =',
#          range(diff(x)), "" ) 
#    stop(val$message)
#  }
  if(val$ier < (-2))warning(val$message) 
  if(val$ier > 0)stop(val$message)
##
## 8.  Clean up
##  
  val$g <- with(val, n-2*(k+1))
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
