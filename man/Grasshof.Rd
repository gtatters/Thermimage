\name{Grasshof}
\alias{Grasshof}
\title{
Determines the Grasshof number for an object
}
\description{
Determines the Grasshof number for an object.  The Grasshof number is used in
calculations of heat exchange.
}
\usage{
Grasshof(L = 1, Ts = 20, Ta = 20)
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
Gr=agL^3(Ts-Ta)/v^2
L is the characteristic dimension, usually the vertical dimension.  For reference, 
a cylinder's characteristic L would be its height, assuming it is standing on its end
Units of L should be in metres
This L should be the same L as is used for the convective coefficient calculation
Ts is the surface temperature
Ta is the ambient temperature
v2 is the kinematic viscosity squared (calculated from airviscosity(Ta))
}
\references{
Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man.
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{airviscosity}}
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (L = 1, Ts = 20, Ta = 20, v = airviscosity(20)) 
{
    a <- 1/273
    g <- 9.81
    Gr <- a * g * L^3 * (Ts - Ta)/v^2
    Gr
  }
}

