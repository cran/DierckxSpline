xyplot.dierckx <- function(x, data, show.knots = FALSE, ...) {
  if(!missing(data)) 
    warning("explicit 'data' specification ignored")
  dots <- list(...)
  data <- data.frame(x = x$x, y = x$y)
  dots$x <- y ~ x
  dots$data <- data
  dots$newx <- seq(min(x$x), max(x$x), len = 200)
  dots$newy <- predict(x, newx = dots$newx)
  if(show.knots) {
    dots$knots <- knots(x)
    dots$knots.y <- predict(x, dots$knots)
  }
  dots$panel <- function(x, y, newx, newy, knots, knots.y, ...) {
    if(show.knots) {
      y0 <- current.panel.limits()$ylim[1]
      col <- trellis.par.get("plot.line")$col
      lsegments(knots, y0, knots, knots.y, col = col, ...)
    }
    panel.xyplot(x, y, ...)
    panel.xyplot(newx, newy, type = "l", ...)
  }
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
