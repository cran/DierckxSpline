###
### Paul Dierckx (1993)
### Curve and Surface Fitting with Splines
### (Oxford U. Pr.)
###
library(DierckxSpline)
##
## Figure 1.1. Graph of a cubic B-Spline
##

# Using the splines package 
library(splines)
(fig1.1x <- seq(1, 5, length=201))

# Using 'splineDesign'
Bspl12345 <- splineDesign(1:5, fig1.1x, outer.ok=TRUE)
Bspl11135 <- splineDesign(c(1,1,1,3,5), fig1.1x, outer.ok=TRUE)
matplot(fig1.1x, cbind(a=Bspl12345, b=Bspl11135), type='l')

# Using 'spline.des'
Bspl12345. <- spline.des(1:5, fig1.1x, outer.ok=TRUE)
Bspl11135. <- spline.des(c(1,1,1,3,5), fig1.1x, outer.ok=TRUE)
matplot(fig1.1x, cbind(a=Bspl12345.$design, b=Bspl11135.$design), type='l')

# Using the 'bs' function 
Bspline12345 <- bs(fig1.1x, knots=1:5)
Bspline11135 <- bs(fig1.1x, knots=c(1,1,1,3,5))

matplot(fig1.1x, cbind(a=Bspline12345[, 4], b=Bspline11135[, 4]),
        type='l')

# Using the 'fda' package
library(fda)
fig1.1a.fda.basis <- create.bspline.basis(c(1, 5), breaks=1:5)
plot(fig1.1a.fda.basis)
# We want the middle of 7 
fig1.1a.fda <- fd(c(0,0,0,1,0,0,0), fig1.1a.fda.basis)
plot(fig1.1x, eval.fd(fig1.1x, fig1.1a.fda), type="l")

fig1.1b.fda.basis <- create.bspline.basis(c(1,9), breaks=c(1,3,5,7,9))
# 7 basis functions with knots (1,1,1,1,3), (1,1,1,3,5),
# (1,1,3,5,7), (1,3,5,7,9), ... 
# We want number 2 of 7 
fig1.1b.fda <- fd(c(0,1,0,0,0,0,0), fig1.1b.fda.basis)
lines(fig1.1x, eval.fd(fig1.1x, fig1.1b.fda), col="red", lty="dashed")

# N0TE:  The 'create.bspline.basis' function in the 'fda' package
#        constructs a basis with coincident boundary knots.
#        A basis with periodic boundary knots can NOT be created
#        using 'create.bpline.basis'.

##
## Figure 1.2. Knot insertion to find the zeros of a spline function 
##

# Figure 1.2:  spline bases 
knots1.2 <- c(0,0,0,0, 2, 4, 7, 8, 10,10,10,10)
wts <- c(1, 2, 5, -5, 5, -1, 3, 3)

# NOTE:
# An attempt to create this Figure using 'curfit'
# failed, because 'curfit' dropped the knots at 2 and 8.
# Therefore, start with library(fda).

fig1.2basis <- create.bspline.basis(c(0, 10),
                                    breaks=c(0, 2, 4, 7, 8, 10))
plot(fig1.2basis)
# Partition of unity, Dierckx, (1.31), p. 11
x1.2 <- seq(0, 10, length=21)
lines(x1.2, apply(eval.basis(fig1.2basis, x1.2), 1, sum), col="red",
      lty="dotted", lwd=3)

# Figure 1.2:  spline object 
fig1.2a.fda <- fd(c(1, 2, 5, -5, 5, -1, 3, 3), fig1.2basis)

plot(fig1.2a.fda, ylim=c(-5, 5))

# Number of sign changes in wts
library(sfsmisc)
nr.sign.chg(wts)
# 4 as in the book and per manual count
# = upper bound for the number of zeros.
names(fig1.2a.fda)
nr.sign.chg(fig1.2a.fda$coefs)
# 4 -- because
all.equal(as.vector(fig1.2a.fda $coefs), wts)
# TRUE

# Figure 1.2:  control polygon   
cP <- controlPolygon(fig1.2a.fda)
lines(cP[, 1], cP[, 2], lty="dotted")

fig1.2a.dierckx <- fd2dierckx(fig1.2a.fda)
cP. <- controlPolygon(fig1.2a.dierckx)
all.equal(cP, cP.)
# mean rel difference = 2e-7

# Figure 1.2:  Knot insertion 
fig1.2b <- insert(fig1.2a.dierckx)
cP2 <- controlPolygon(fig1.2b)
lines(cP2[, 1], cP2[, 2], lty="dashed")

fig1.2c <- insert(fig1.2b, c(2.5, 3.5, 4.75, 6.25))
cP3 <- controlPolygon(fig1.2c)
lines(cP3[, 1], cP3[, 2])

abline(v=knots(fig1.2b), lty="dotted", col="light blue")
knots(fig1.2b)
#[1] 1.0 2.0 3.0 4.0 5.5 7.0 7.5 8.0 9.0

# Conclusion:
# One zero between 3 and 4
# and another between 4 and 5.5

(sZ <- splineZeros(fig1.2a.dierckx))
abline(v=sZ[, "root"], col="red", lty="dashed")
