insert <- function(object, ...) {
  UseMethod("insert")
}

insert.dierckx <- function(object, at, ...) {
  if(missing(at) || !length(at)){    
#    stop("no knots to insert")
    Knots <- knots(object, interior=FALSE)
    uKn <- sort(unique(Knots))
    at <- 0.5*(uKn[-1]+uKn[-length(uKn)]) 
  }
  m <- length(at)
  iopt <- 0
  nest <- as.integer(object$nest)
  for(i in seq(m)) {
    sp <- .Fortran("insert",
                   iopt = as.integer(iopt),
                   t = as.single(object$knots),
                   n = as.integer(object$n),
                   c = as.single(object$coef),
                   k = as.integer(object$k),
                   x = as.single(at[i]),
                   tt = single(nest),
                   nn = integer(1),
                   cc = single(nest),
                   nest = nest,
                   ier = integer(1))
    object$n <- sp$nn
    object$knots <- as.double(sp$tt)
    object$coef <- as.double(sp$cc)
    object$g <- object$g+1
  }
  object$sp <- fitted(object)
  object
}
