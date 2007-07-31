curfit <- function(x, ...) {
  UseMethod("curfit")
}

percur <- function(x, ...) {
  curfit(x, periodic = TRUE, ...)
}

curfit.formula <- function(x, data, ..., weights, subset) {
  msg <- "NOT IMPLEMENTED YET;  USE 'curfit.default'." 
  print(msg)
  msg
#  cl <- match.call()
#  mf <- match.call(expand.dots = FALSE)
#  m <- match(c("x", "data", "subset", "weights"), names(mf), 0)
#  mf <- mf[c(1, m)]
#  mf$drop.unused.levels <- TRUE
#  mf[[1]] <- as.name("model.frame")
#  mf <- eval(mf, parent.frame())
#  y <- model.response(mf, "numeric")
#  w <- model.weights(mf)
#  mt <- attr(mf, "terms")
#  x <- x[[length(x)]]
#  if(length(x) == 3 && x[[1]] == as.name("|"))
#    x <- x[[2]]
#  x <- eval(substitute(x), mf)
#  curfit(x, y, w, ...)  
}

curfit.default <- function(x, y = NULL, w = NULL, s=NULL, knots = NULL,
                           n = NULL, from = min(x), to = max(x),
                           k = 3, periodic = FALSE, ...) {
##
## 1.  Check k = degree of the spline.  
##  
  if(k - floor(k) > 0)
    warning("'k' must be an integer and will be truncated from ",
            k, " to ", floor(k), ".")
  k <- as.integer(k)
  if(k < 1 || k > 5)
    stop("'k' must be between 1 and 5, inclusively.  ",
         "For step functions or splines of degree exceeding 5, try ",
         "the fda package.")
##
## 2.  Check x, y, w
##
  xlabChk <- function(xlab, xch="x"){
    long <- (length(xlab)>1)
    c. <- (substr(xlab, 1, 2) == "c(")
    num <- regexpr("^[:digits:]", xlab)
    point <- (substring(xlab, 1,1) %in%
              c(".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9") )
    if(long || c. || num || point) xlab <- xch
    xlab
  }
  xlab <- deparse(substitute(x))
  xlab <- xlabChk(xlab) 
#  if((length(xlab) > 1) || (substr(xlab, 1, 2) == "c(")) xlab <- "x"
  ylab <- deparse(substitute(y))
  ylab <- xlabChk(ylab, "y")
#  if((length(ylab) > 1) || (substr(ylab, 1, 2) == "c(")) ylab <- "y"
# Fix 'from' and 'to' before playing with 'x'.  
  From <- from
  To <- to 
  xyw <- xyw.coords(x, y, w)
  xyw$xlab <- xlab
  xyw$ylab <- ylab  
#  x <- xyw$x
#  y <- xyw$y
#  w <- xyw$w
#  xin <- xyw$xin
#  yin <- xyw$yin
#  m <- length(x) # WRONG:  m = actual not initial length(x) 
  if(from > min(xyw$x)) {
    warning("dropping values of x below ", from)
    keep <- (xyw$x >= from)
    xyw$x <- xyw$x[keep]
    xyw$y <- xyw$y[keep]
    xyw$w <- xyw$w[keep]
  }
  if(to < max(xyw$x)) {
    warning("dropping values of x above ", to)
    keep <- (xyw$x <= to)
    xyw$x <- xyw$x[keep]
    xyw$y <- xyw$y[keep]
    xyw$w <- xyw$w[keep]
  }
  m <- length(xyw$x) 
##
## 3.  Least Squares?
##
# LS1, LS2, LS3 = the three criteria for the least squares method:    
  LS1 <- is.null(s)
  LS2 <- !(is.null(knots) & is.null(n))
  LS3 <- (max(length(knots), n) <= (m+k+1))  
  if(LS1 && LS2 && LS3) 
    return(curfitLS(xyw, s=s, knots=knots, n=n, from=From,
         to=To, k=k, periodic=periodic, ... ) )
##
## 4.  Smoothing spline?
##
  dots <- list(...)  
# update?  
  wrkNames <- c("wrk", "lwrk", "iwrk")
  missingWrk <- !(wrkNames %in% names(dots))
#
  if(all(missingWrk))
    return(curfitSS(xyw, s=s, knots=knots, n=n, from=From,
         to=To, k=k, periodic=periodic, ... ))
##
## 5.  Update?
##
  if(any(missingWrk))
    stop("Inappropriate update:  dots does not include ",
         paste(wrkNames[missingWrk], paste=", ") )
#
  if("xlab" %in% names(dots)) xyw$xlab <- dots$xlab
  if("ylab" %in% names(dots)) xyw$ylab <- dots$ylab
  curfitUpdate(xyw, s=s, knots=knots, n=n, from=From,
         to=To, k=k, periodic=periodic, ... )
}
