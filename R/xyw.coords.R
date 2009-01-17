xyw.coords <- function(x, y = NULL, w = NULL, v = NULL, ...) {
  xy <- xy.coords(x, y)
#  x <- xin <- xy$x
  xin <- xy$x
#  y <- yin <- xy$y
  yin <- xy$y
  m <- length(xin)
  if(is.null(w)) w <- rep(1, m)
  if(length(w) == 1) w <- rep(w, m)
  if(length(w) != m)
    stop("length of 'w' (weights) needs to be ", m, ", not ", length(w))
  if(is.null(v)) v <- rep(0, m)
  if(length(v) == 1) v <- rep(v, m)
  if(length(v) != m)
    stop("length of 'v' needs to be ", m, ", not ", length(v))
  x6 <- signif(xin, 6)
  if(any(duplicated(x6))) {
    ux <- sort(unique(x6))
    ox <- match(x6, ux)
    yw <- yin * w
# NOTE:  tappy returns 1-d arrays here
# with names = 1, 2, ... (number of distinct levels of x)
# The array information seems a waste at best
# and makes it difficult to compare the answers with     
# manual computations using 'all.equal',
# so delete the array information     
#    y <- tapply(y, ox, sum)
    y2 <- as.numeric(tapply(yw, ox, sum))
    w <- as.numeric(tapply(w, ox, sum))
    v2 <- as.numeric(tapply(v, ox, sum))
    v <- ifelse(v2 > 0, 1, ifelse(v2 < 0, -1, 0))
    y <- y2/w
    x <- as.numeric(tapply(xin, ox, mean))
  }
  m2 <- length(x)
  if(m2 < 4){
    ermsg <- paste("Need at least 4 distinct x values.  Only",
                   m2, "distinct values found")
    if(m2<m)
      ermsg <- paste(ermsg, "(after combining observations equal to",
                     "6 significant digits starting from", m,
                     "observations)")
    stop(ermsg) 
  }
  o <- order(x)
  list(x = x[o], y = y[o], w = w[o], v = v[o], xin = xin, yin = yin)
}
