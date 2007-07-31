library(DierckxSpline)
##
## slide 5.  Smoothing splines
##
     x <- 0:24
     y <- c(1.0,1.0,1.4,1.1,1.0,1.0,4.0,9.0,13.0,
            13.4,12.8,13.1,13.0,14.0,13.0,13.5,
            10.0,2.0,3.0,2.5,2.5,2.5,3.0,4.0,3.5)

ss <- list()
s <- c(0, 10, 100, 1000)
for(i in seq(s)) {
  ss[[i]] <- curfit(x, y,
    s = s[i], method = "ss")
}

str(ss)
class(ss)

sapply(ss, class)
#[1] "dierckx" "dierckx" "dierckx" "dierckx"

xyplot(ss[[1]], show.knots=TRUE)
xyplot(ss[[2]], show.knots=TRUE)
xyplot(ss[[3]], show.knots=TRUE)
xyplot(ss[[4]], show.knots=TRUE)

##
## slide 6.  Comparison To smooth.spline
##
## example from ?smooth.spline
## This example has duplicate points, so avoid cv = TRUE
cars.spl.0 <- smooth.spline(cars$speed, cars$dist, df=2.6)
cars.spl.1 <- smooth.spline(cars$speed, cars$dist, df = 10)
cars.spl.2 <- curfit(cars$speed, cars$dist, s = 5e3)

plot(dist~speed, cars)
(xlim <- range(cars$speed))
x. <- seq(xlim[1], xlim[2], len=201)
pred.spl.0 <- predict(cars.spl.0, x.)
lines(pred.spl.0, lwd=2, col="blue")
pred.spl.1 <- predict(cars.spl.1, x.)
lines(pred.spl.1, lwd=2, col="red", lty="dashed")

pred.spl.2 <- predict(cars.spl.2, x.)
lines(x., pred.spl.2, lwd=2, lty="dotted")

##
## slide 7.  Least Squares Splines With Fixed Knots
##
n <- c(5, 10, 15, 20)
ls <- list()
for(i in seq(n)) {
  kn <- seq(0, 24, len = n[i])
  ls[[i]] <- curfit(x, y,
    method = "ls", knots = kn)
}

xyplot(ls[[1]], show.knots=TRUE)
xyplot(ls[[2]], show.knots=TRUE)
xyplot(ls[[3]], show.knots=TRUE)
xyplot(ls[[4]], show.knots=TRUE)

##
## slide 8.  Least Squares Splines with Variable Knots
##
data(titanium)
r <- curfit.free.knot(titanium$x2,
   titanium$y, g = 10, eps = 5e-4)
class(r)
xyplot(r)

curfixed <- vector("list", 6)
curfree <- curfixed

for(gi in 1:6){
  curfixed[[gi]] <- curfit(titanium$x2,
   titanium$y, n =gi+7)
#  
  curfree[[gi]] <- curfit.free.knot(titanium$x2,
   titanium$y, g =gi , eps = 5e-4)
}

plot(curfree[[1]], show.knots=TRUE)
xlim <- range(titanium$x2)
x2. <- seq(xlim[1], xlim[2], length=201)
y.fixed <- predict(curfixed[[1]], x2.)
quantile(y.fixed)

lines(x2., y.fixed, lty="dashed")

