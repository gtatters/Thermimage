\name{Grashof}
\alias{Grashof}
\title{
Determines the Grashof number for an object
}
\description{
Determines the Grashof number for an object.  The Grashof number is used in
calculations of heat exchange.
}
\usage{
Grashof(L = 1, Ts = 25, Ta = 20)
}
\arguments{
  \item{L}{
Characteristic dimension of object in metres.  Usually height, depending on object shape.
}
  \item{Ts}{
Surface Temperature of object, in degrees Celsius.
}
  \item{Ta}{
Air/Ambient Temperature surrounding object, in degrees Celsius.
}
}
\details{
The Grashof number is a dimensionless number describing the ability of a parcel of fluid 
warmer or colder than the surrounding fluid to rise against or fall with the attractive
force of gravity as follows:
Gr=agL^3(Ts-Ta)/v^2
where
L is the characteristic dimension, usually the vertical dimension.  For reference, 
a cylinder's characteristic L would be its height, assuming it is standing on its end
Units of L should be in metres
This L should be the same L as is used for the convective coefficient calculation
Ts is the surface temperature
Ta is the ambient temperature
v2 is the kinematic viscosity squared (calculated from airviscosity(Ta))
}
\references{
Blaxter, K. 1989.  Energy Metabolism in Animals and Man.
Gates, D. M. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York.  611 pp.
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{airviscosity}}
}
\examples{
## The function is currently defined as
function (L = 1, Ts = 25, Ta = 20) 
{
    a <- 1/273
    g <- 9.81
    Gr <- a * g * L^3 * (Ts - Ta)/v^2
    Gr
  }

# Typical values for Grashof number range from 0.016 to 4.6e+09 if Ts-Ta varies from 
# 0.1 to 30oC

# Example calculation:
L<-1
Ts<-30
Ta<-20
Grashof(L, Ts, Ta)  

}

