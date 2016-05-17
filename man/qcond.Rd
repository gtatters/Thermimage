\name{qcond}
\alias{qcond}
\title{
Estimates the area specific heat transfer by conduction (W/m2)
}
\description{
Estimates the area specific heat transfer by conduction (W/m2).  Positive 
}
\usage{
qcond(Ts = 30, Tc = 20, ktiss = 0.502, x = 1)
}
\arguments{
  \item{Ts}{
Surface temperature (degrees Celsius).  Default value is 30.
}
  \item{Tc}{
Contact temperature (degrees Celsius), usually ground temperature.  Default value is 20.
}
  \item{ktiss}{
Thermal conductivity of tissue (W/m/oC).
}
  \item{x}{
Distance over which heat is conducted.  Default value is 1 m (unrealistic, but easier for converting)
}
}
\details{
Usually conductive heat transfer is ignored given little surface area will be in contact with the ground, but this is included for functionality.
}

\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{qrad}}
\code{\link{qconv}}
}
\examples{
## The function is currently defined as
function (Ts = 30, Tc = 20, ktiss = 0.502, x = 1) 
{
    qcond <- ktiss * (Tc - Ts)/x
    qcond
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
