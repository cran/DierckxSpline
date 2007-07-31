concon <- function(x, ...) {
  UseMethod("concon")
}

concon.default <- function(x, y = NULL, w = NULL, v = 0, s = 0, ...) {
  dots <- list(...)
  knots <- dots$knots
  iopt <- as.integer(if(is.null(knots)) 0 else 1)
  xlab <- deparse(substitute(x))
  ylab <- deparse(substitute(y))
  xyw <- xyw.coords(x, y, w, v)
  x <- xyw$x
  y <- xyw$y
  w <- xyw$w
  v <- xyw$v
  xin <- xyw$xin
  yin <- xyw$yin
  m <- length(x)
  if(all(v == 0)) stop("unconstrained spline: use 'curfit' instead.")
  if(s < 0)
    stop("Smoothing factor 's' must be strictly non-negative.")
  nest <- if("nest" %in% names(dots)) dots$nest else -1
  nest <- as.integer(max(nest, m + 4))
  maxtr <- if("maxtr" %in% names(dots)) dots$maxtr else -1
  maxtr <- as.integer(max(maxtr, 1000))
  maxbin <- if("maxbin" %in% names(dots)) dots$maxbin else -1
  maxbin <- as.integer(max(maxbin, 100))
  knots <- if(iopt != 1) single(nest) else as.single(knots)
  lwrk <- if("lwrk" %in% names(dots)) dots$lwrk else -1
  lwrk <- as.integer(max(lwrk, 2 * (m * 4 + nest * 8 + maxbin * (maxbin + nest + 1))))
  kwrk <- if("kwrk" %in% names(dots)) dots$kwrk else -1
  kwrk <- as.integer(max(kwrk, maxtr * 4 + 2 * (maxbin + 1)))
  if(iopt == 1) {
    if(any(!c("wrk", "iwrk") %in% names(dots)))
      stop("Cannot update fit. Did you use 'update.dierckx'?")
    wrk <- as.single(dots$wrk)
    iwrk <- as.integer(dots$iwrk)
  } else {
    wrk <- single(lwrk)
    iwrk <- integer(kwrk)
  }
  n <- if("n" %in% names(dots)) as.integer(dots$n) else integer(1)
  sx <- if("sx" %in% names(dots)) as.single(dots$sx) else single(m)
  bind <- if("bind" %in% names(dots)) as.integer(dots$bind) else integer(nest)
  ## subroutine concon(iopt,m,x,y,w,v,s,nest,maxtr,maxbin,n,t,c,sq,sx,bind,wrk,lwrk,iwrk,kwrk,ier)
  val <- .Fortran("concon",
                  iopt = iopt,
                  m = m,
                  x = as.single(x),
                  y = as.single(y),
                  w = as.single(w),
                  v = as.single(v),
                  s = as.single(s),
                  nest = nest,
                  maxtr = maxtr,
                  maxbin = maxbin,
                  n = n,
                  knots = knots,
                  coef = single(nest),
                  fp = single(1),
                  sx = sx,
                  bind = bind,
                  wrk = wrk,
                  lwrk = lwrk,
                  iwrk = iwrk,
                  kwrk = kwrk,
                  ier = integer(1))
  val$message <- if(val$ier == 0) {
    character(0)
  } else if(val$ier == -3) {
    sprintf("The requested storage space exceeds the available. Probable cause: nest (%d) or s (%f) are too small", val$nest, val$s)
  } else if(val$ier == -2) {
    sprintf("The maximal number of knots (%d) has bee reached. Probable cause: s (%f) is too small.", val$n, val$s)
  } else if(val$ier == -1) {
    sprintf("The number of knots (%d) is less than the maximal number. Probable cause: s (%f) is too small.", val$n, val$s)
  } else if(val$ier == 1) {
    sprintf("The number of knots (%d) where s''(x)=0 exceed maxbin. Probable cause: maxbin (%d) is too small", val$n, val$maxbin)
  } else if(val$ier == 2) {
    sprintf("The number of records in the tree structure exceed maxtr. Probable cause: maxtr (%d) is too small", val$maxtr)
  } else if(val$ier == 3) {
    "The algorithm finds no solution to the posed quadratic programming problem. Probable cause: rounding error"
  } else if(val$ier == 4) {
    sprintf("The minimum number of knots (%d) to guarantee concavity/convexity conditions will be satisfied is greater than nest. Probable cause: nest (%d) is too small.", val$n, val$nest)
  } else if(val$ier == 5) {
    sprintf("The minimum number of knots (%d) to guarantee concavity/convexity conditions will be satisfied is greater than m+4 (%d). Probable cause: strongly alternating convexity and concavity conditions.", val$n, val$m + 4)
  } else if(val$ier == 10) {
    ""
  }
  if(val$ier == 10) {
    if(val$iopt > 1 || val$iopt < 0)
      val$message <- sprintf("%s Illegal option %d.", val$message, val$iopt)
    if(val$nest < 8)
      val$message <- sprintf("%s Illegal value of 'nest' (%d).", val$message, val$nest)
    if(val$maxtr < 1)
      val$message <- sprintf("%s Illegal value of 'maxtr' (%d).", val$message, val$maxtr)
    if(val$maxbin < 1)
      val$message <- sprintf("%s Illegal value of 'maxbin' (%d).", val$message, val$maxbin)
    if(val$lwrk < with(val, m * 4 + nest * 8 + maxbin * (maxbin + nest + 1)))
      val$message <- sprintf("%s Illegal value of 'lwrk' (%d).", val$message, val$lwrk)
    if(val$kwrk < with(val, maxtr * 4 + 2 * (maxbin + 1)))
      val$message <- sprintf("%s Illegal value of 'kwrk' (%d).", val$message, val$kwrk)
  }
  val$k <- 3
  val$g <- with(val, length(knots[knots > min(x) & knots < max(x)]))
  val$sp <- fitted(val)
  sing <- names(unlist(sapply(val, attr, "Csingle")))
  val[sing] <- lapply(val[sing], as.double)
  val$method <- "convexity constrained"
  val$periodic <- FALSE
  val$routine <- "concon.default"
  val$xlab <- xlab
  val$ylab <- ylab
  if(length(xin) > m) {
    val$x <- xin
    val$y <- yin
    val$sp <- predict.dierckx(val, newx = xin)
  } else {
    val$sp <- fitted(val)
  }
  class(val) <- "dierckx"
  val
}
