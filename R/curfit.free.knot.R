curfit.free.knot <- function(x, y, w = NULL, k = 3, g = 10, eps = 0.5e-3,
                             prior = NULL, fixed = NULL, trace=1, ...) {
##
## 1.  Define internal functions
##  
  penalty.opt <- function(kn, x, y, k, sigma0, eps, fixed = NULL, ...) {
    kn <- sort(c(kn, fixed))
    if(length(u <- unique(kn)) < length(kn))
      stop(sprintf("%d coincident knot(s) detected",
                   length(kn) - length(u)))
#   'method' is not an argument of 'curfit';  delete?  
    sp <- curfit(x, y, method = "ls", knots = kn, k=k, ...)
    p <- eps * sigma0/((sp$g + 1)^2/(diff(range(x))))
    pen <- p * sum(1/diff(unique(knots(sp, FALSE))))
    sp$fp + pen
  }
  penalty.gr <- function(kn, x, y, k, sigma0, eps, fixed = NULL, ...) {
    kn <- sort(c(kn, fixed))
    sp <- curfit(x, y, knots = kn, k = k, ...)
    r <- resid(sp)
    lambda <- knots(sp, FALSE)
    cf <- sp$coef[seq(along = lambda)]
    g <- sp$g
    k <- sp$k
    p <- eps * sigma0/((g + 1)^2/(diff(range(x))))
    m <- length(x)
    d.pen <- numeric(g)
    d.sp <- numeric(g)
    for(j in seq(g)) {
      l <- j + k + 1
      d.pen[j] <- ((lambda[l + 1] - lambda[l])^(-2) -
                   (lambda[l] - lambda[l - 1])^(-2) )
      lambda.j <- c(lambda[1:(k + j + 1)],
                    lambda[(k + j + 1):(g + 2 * k + 2)])
      e.j <- numeric(length(lambda))
      i <- (l - k):l
      e.j[i] <- (cf[i - 1] - cf[i])/(lambda.j[i + k + 1] - lambda.j[i])
      n <- length(lambda.j)
      d.sp.r <- .Fortran("splev",
                         knots = as.single(lambda.j),
                         n = as.integer(n),
                         coef = as.single(e.j),
                         k = as.integer(k),
                         x = as.single(x),
                         sp = single(m),
                         m = as.integer(m),
                         ier = as.integer(sp$ier))$sp
      d.sp[j] <- -2 * sum(r * d.sp.r)
    }
    d.sp + p * d.pen
  }
##
## 2.  Fit model(s) 
##  
  m <- length(x)
  a <- min(x)
  b <- max(x)
  w <- if(is.null(w)) rep(1, m) else rep(w, length = m)
  shift <- .Machine$double.eps^0.25
  if(!is.null(prior)) {
#  2.1.  Only one model     
    g <- length(prior)
    index <- -1
#   'method' is not an argument of 'curfit';  delete? 
    sp0 <- curfit(x, y, method = "ls", knots = sort(c(prior, fixed)),
                  k=k, ...)
    sigma0 <- deviance(sp0, TRUE)
    lambda1 <- if(length(prior) > 1) {
      optim(prior, penalty.opt, if(is.null(fixed)) penalty.gr,
            x = x, y = y, k = k, sigma0 = sigma0,
            lower = a + shift, upper = b - shift, method = "L-BFGS-B",
            eps = eps, fixed = fixed,
            control=list(trace=trace-1))$par
    } else {
      optimize(penalty.opt, c(a, b), x = x, y = y, k = k,
               sigma0 = sigma0, eps = eps, fixed = fixed)$minimum
    }
#   'method' is not an argument of 'curfit';  delete?      
    sp1 <- curfit(x, y, method = "ls", knots = sort(c(lambda1, fixed)),
                  k=k, ...)
    r <- resid(sp1)
    sigma <- deviance(sp1, TRUE)
    T <- deviance(sp1) + 2 * (sp1$g + sp1$k)
    summ <- data.frame(g = g, sigma = sigma, T = T)
  } else {
#  2.2.  models with 1:g knots 
    index <- -1
    seq.g <- {
      if(length(g) == 1) seq(g)
      else seq(min(g), max(g))
    }
    ng <- length(seq.g) 
    sigma <- T <- numeric(ng)
    sp1 <- vector("list", ng)    
    for(i in seq(seq.g)) {
      g.i <- seq.g[i]
      lamb0 <- if(i == 1) {
        seq(a, b, length = g.i + 2)[-c(1, g.i + 2)]
      } else {
        r <- resid(sp1[[i - 1]])
        q <- cut(sp1[[i - 1]]$x, c(-Inf, lambda0, Inf))
        delta <- tapply(r, q, function(ri) sum(ri^2)/(m - length(ri)))
        l <- which.max(delta)
        lam0 <- sort(c(lambda0, fixed))
        n. <- length(lam0)
        if(l == 1) {
          c((a + lam0[1])/2, lam0)
        } else if(l == n. + 1) {
          c(lam0, (b + lam0[n.])/2)
        } else {
          c(lam0[1:(l - 1)], (lam0[l] + lam0[l - 1])/2, lam0[l:n.])
        }
      }
      lambda0 <- lamb0[!(lamb0 %in% fixed)]
      if(trace>1)cat(lambda0) 
#     The following fails to pass k:  fix.  
#      sp0 <- curfit(x, y, method = "ls", knots = c(lambda0, fixed), ...)
      sp0 <- curfit.default(x, y, w, method = "ls",
                            knots = sort(c(lambda0, fixed)), k=k, ...)
#     Also:  'method' is not an argument of 'curfit';  delete?        
      sigma0 <- deviance(sp0, TRUE)
      lambda1 <- if(length(lambda0) > 1) {
        optim(lambda0, penalty.opt, NULL,#if(is.null(fixed)) penalty.gr,
              x = x, y = y, k = k, sigma0 = sigma0,
              lower = a + shift, upper = b - shift, method = "L-BFGS-B",
              eps = eps, fixed = fixed,
              control=list(trace=trace-1))$par
      } else {
        optimize(penalty.opt, c(a, b), x = x, y = y, k = k,
                 sigma0 = sigma0, eps = eps, fixed = fixed)$minimum
      }
#     sp1[[i]] <- curfit(x, y, method = "ls", knots = c(lambda1, fixed), ...)
      sp1[[i]] <- curfit.default(x, y, w, method = "ls",
                       knots = sort(c(lambda1, fixed)), k=k, ...)
#     'method is not an argument of 'curfit';  delete?        
      r <- resid(sp1[[i]])
      sigma[i] <- deviance(sp1[[i]], TRUE)
      T[i] <- sqrt(m - 1) * sum(r[-1] * r[-m])/sum(r^2)
      if(i > 1 && T[i] < 0 && T[i - 1] > 0 && index < 0) index <- i
      lambda0 <- sort(lambda1)
      if(trace>0)
        cat("", g.i, "knots, residual variance =",
            sigma[i], ";  z.acf1 = ", T[i], "\n") 
    }
    summ <- data.frame(g = seq.g, sigma = sigma, T = T)
    names(sp1) <- seq.g
  }
##
## 3.
##   
  if(is.null(prior)) {
    ret <- if(index > 0) sp1[[index]] else sp1[[length(sp1)]]
    ret <- c(ret, list(fits = sp1))
  } else {
    ret <- sp1
  }
  ret <- c(ret, list(summary = summ))
  class(ret) <- c("dierckx", "list")
  ret
}
