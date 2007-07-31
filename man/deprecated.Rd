\name{deprecated}
\alias{dierckx2fd}
\alias{fd2dierckx}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  depricated
}
\description{
  Use \code{as.fd.dierckx} (in the \code{fda} package) instead of
  \code{dierckx2fd} and \code{as.dierckx.fd} in place of
  \code{fd2dierckx}.  
}
\usage{
dierckx2fd(object)
fd2dierckx(object) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{
    an object of class dierckx (for 'dierckx2fd') or fd (for
    'fd2dierckx') to be translated into the other class.
  }
}
\details{
  See the documentation for \code{as.dierckx}.     
}
%\value{
%  See the documentation for \code{as.dierckx}.     
%}
%\references{
%Dierckx, P. (1991) \emph{Curve and Surface Fitting with Splines}, Oxford
%Science Publications.

%  Ramsay, James O., and Silverman, Bernard W. (2006), \emph{Functional
%    Data Analysis, 2nd ed.}, Springer, New York. 

%  Ramsay, James O., and Silverman, Bernard W. (2002), \emph{Applied
%    Functional Data Analysis}, Springer, New York. 
%}
\author{Spencer Graves}
\seealso{
  \code{\link{as.dierckx}}
  \code{\link[fda]{as.fd}}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{smooth}
\keyword{manip}
