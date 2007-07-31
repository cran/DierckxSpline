knots.dierckx <- function(Fn, interior = TRUE, ...) {
  if(interior) {
    kn <- Fn$knots
    k <- Fn$k
    g <- Fn$g
    if(g > 0) kn[seq(g) + k + 1] else numeric(0)
  } else {
    Fn$knots[seq(Fn$n)]
  }
}
