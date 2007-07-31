panel.dierckx <- function(x, y, newx, newy,
                      knots = NULL, knots.y = NULL, lty = 2,
                      knot.cex = 1.5, knot.col = "red",
                      knot.fill = "lightgray", ...) {
  if(!is.null(knots) && !is.null(knots.y)) {
    ylim <- current.panel.limits()$ylim
    knots.y <- pmin(knots.y, ylim[2])
    ##lsegments(knots, ylim[1], knots, knots.y, col = knot.col, ...)
    knots <- c(min(x), knots, max(x))
    lpoints(knots, ylim[1], pch = 22, cex = knot.cex,
            fill = knot.fill, col = knot.col, ...)
  }
  panel.xyplot(x, y, ...)
  panel.xyplot(newx, newy, lty = lty, type = "l", ...)
}


xyplot.dierckx <- function(x, data, panel = "panel.dierckx",
                           show.knots = FALSE, ...) {
  if(!missing(data)) 
    warning("explicit 'data' specification ignored")
  dots <- list(...)
  data <- data.frame(x = x$x, y = x$y)
  dots$x <- y ~ x
  dots$data <- data
#  dots$newx <- seq(min(x$x), max(x$x), len = 201)
# sometimes dots$newx gets lost;  I don't know why.  sg 2008.01.12  
#  dots$newy <- predict(x, newdata = dots$newx) 
  newx. <- seq(min(x$x), max(x$x), len = 201)
  dots$newx <- newx.
  dots$newy <- predict(x, newdata = newx.)
#
  if(show.knots) {
    dots$knots <- knots(x)
    if(length(dots$knots)) {
      dots$knots.y <- predict(x, dots$knots)
      dots$par.settings <- list(clip = list(panel = "off"))
    } else {
      dots$knots <- NULL
    }
  }
  dots$panel <- panel
  if(is.null(dots$xlab)) {
    dots$xlab <- x$xlab
  } else if(!is.character(dots$xlab[[1]])) {
    dots$xlab <- c(list(x$xlab), dots$xlab)
  }
  if(is.null(dots$ylab)) {
    dots$ylab <- x$ylab
  } else if(!is.character(dots$ylab[[1]])) {
    dots$ylab <- c(list(x$ylab), dots$ylab)
  }
  if(is.null(dots$ylim)) {
    dots$ylim <- range(c(data$y, dots$newy))
    dots$ylim <- dots$ylim + 0.03 * c(-1, 1) * diff(range(dots$ylim))
  }
  do.call("xyplot", dots)
}
