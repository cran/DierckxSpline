profile.dierckx <- function(fitted, which = 1:g, alpha = 0.01, maxsteps = 10, ...) {
  g <- fitted$g
  if(any(!which %in% 1:g))
    stop(sprintf("'which' must be between 1 and %s, inclusively", g))
  n <- length(fitted$x)
  p <- fitted$g# + fitted$k
  zmax <- sqrt(p * qf(1 - alpha/2, p, n - p))
  x <- fitted$x
  y <- fitted$y
  kn <- knots(fitted)
  pv0 <- t(as.matrix(kn))
  dev <- vector("numeric", length(kn))
  prof <- vector("list", length = length(which))
  names(prof) <- which
  a <- min(x)
  b <- max(x)
  for(i in which) {
    zi <- 0
    pvi <- pv0
    ki <- kn[i]
    pi <- as.character(i)
    devi <- deviance(fitted)
    sigma <- deviance(fitted, scale = TRUE)^0.5
    for(sgn in c(-1, 1)) {
      step <- z <- 0
      del <- if(sgn < 0) {
        (kn[i] - (if(i == 1) a else kn[i - 1]))/maxsteps
      } else {
        ((if(i == g) b else kn[i + 1]) - kn[i])/maxsteps
      }
      while((step <- step + 1) < maxsteps && abs(z) < zmax) {
        kni <- kn
        kni[i] <- kni[i] + sgn * step * del
        fm <- curfit(x, y, knots = kni)
        zz <- (deviance(fm) - devi)/sigma
        z <- sgn * sqrt(max(zz, 0))
        zi <- c(zi, z)
        ki <- c(ki, kni[i])
      }
    }
    si <- order(ki)
    prof[[pi]] <- data.frame(ki[si], zi[si])
    names(prof[[pi]]) <- c("knots", "tau")
  }
  prof$original.fit <- fitted
  class(prof) <- c("profile.dierckx", "profile")
  prof
}

#confint.dierckx <- function(object, knots = 1:g, level = 0.95, ...) {
confint.dierckx <- function(object, parm = 1:g, level = 0.95, ...) {
  g <- object$g
  message("Waiting for profiling to be done...")
  utils::flush.console()
#  object <- profile(object, knots = knots, alpha = (1 - level)/4)
  object <- profile(object, knots = parm, alpha = (1 - level)/4)
#  confint(object, knots = knots, level = level, ...)
  confint(object, parm = parm, level = level, ...)
}

#confint.profile.dierckx <- function(object, knots = 1:g, level = 0.95, ...) {
confint.profile.dierckx <- function(object, parm = 1:g,
                                    level = 0.95, ...) {
  fit <- object$original.fit
  g <- fit$g
  a <- (1 - level)/2
  a <- c(a, 1 - a)
  pct <- paste(round(100 * a, 1), "%")
#  ci <- array(NA, dim = c(length(knots), 3), dimnames = list(knots, c("knots", pct)))
  ci <- array(NA, dim = c(length(parm), 3), dimnames =
              list(parm, c("knots", pct)))
  cutoff <- qnorm(a)
#  for(i in seq_along(knots)) {
  for(i in seq_along(parm)) {
#    pro <- object[[as.character(knots[i])]]
    pro <- object[[as.character(parm[i])]]
    if(is.null(pro)) next
    ci.k <- if(all(pro[, "tau"] == 0)) {
      c(NA, NA)
    } else {
      sp <- spline(x = pro[, "knots"], y = pro[, "tau"])
      approx(sp$y, sp$x, xout = cutoff)$y
    }
    if(is.na(ci.k[1])) {
      ci.k[1] <- if(i == 1) min(fit$x) else knots(fit)[i - 1]
      rownames(ci)[i] <- sprintf("*%s", rownames(ci)[i])
    }
    if(is.na(ci.k[2])) {
      ci.k[2] <- if(i == g) max(fit$x) else knots(fit)[i + 1]
      rownames(ci)[i] <- sprintf("%s*", rownames(ci)[i])
    }
    ci[i, ] <- c(knots(fit)[i], ci.k)
  }
  drop(ci)
}

xyplot.profile.dierckx <- function(x, data, yscale = c("percentile", "quantile"), ...) {
  if(!missing(data)) 
    warning("explicit 'data' specification ignored")
  yscale <- match.arg(yscale)
  dots <- list(...)
  prof <- x[!names(x) == "original.fit"]
  data <- do.call("rbind", prof)
  data$knot.index <- factor(rep(names(prof), sapply(prof, nrow)), levels = names(prof))
  dots$x <- tau ~ knots | knot.index
  dots$data <- data
  if(is.null(dots$panel)) {
    dots$panel <- function(...) {
      panel.abline(h = 0, lty = 2, col = "darkred")
      panel.xyplot(...)
    }
  }
  if(is.null(dots$type)) dots$type <- "b"
  if(is.null(dots$xlab)) {
    dots$xlab <- x$original.fit$xlab
  } else if(!is.character(dots$xlab[[1]])) {
    dots$xlab <- c(list(x$original.fit$xlab), dots$xlab)
  }
  if(is.null(dots$ylab)) {
    dots$ylab <- sprintf("Standard normal %ss", yscale)
  } else if(!is.character(dots$ylab[[1]])) {
    dots$ylab <- c(list(sprintf("Standard normal %ss", yscale)), dots$ylab)
  }
  if(is.null(dots$as.table)) dots$as.table <- TRUE
  if(yscale == "percentile") {
    q <- c(0.0001, 0.001, 0.01, 0.05, 0.5)
    q <- c(q, rev(1 - q[-length(q)]))
    if(is.null(dots$scales)) dots$scales <- list()
    if(is.null(dots$scales$y)) dots$scales$y <- list()
    dots$scales$y$at <- qnorm(q)
    dots$scales$y$labels <- sprintf("%s%%", sapply(q * 100, format))
  }
  do.call("xyplot", dots)
}
