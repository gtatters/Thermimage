\name{qconv}
\alias{qconv}
\title{
Estimates the area specific heat transfer by convection (W/m2)
}
\description{
Estimates heat transfer by convective heat exchange, using the heat transfer coefficient estimate, surface temperature, and air temperature.  Positive value = heat gain from air to object.  Negative value = heat loss from object to air.
}
\usage{
qconv(Ts = 30, Ta = 20, V = 1, L = 0.1, c = NULL, n =NULL, a=NULL, b = NULL, m = NULL, 
type = "forced", shape="hcylinder")
}
\arguments{
\item{Ts}{
Surface temperature (degrees celsius).  Default value is 30.
}
  \item{Ta}{
Air temperature (degrees celsius). Default value is 20.
}
  \item{V}{
Air velocity (m/s).  Default value is 1.
}
  \item{L}{
Characteristic dimension (m) of object.  Usually the vertical dimension (i.e. height). Default value is 0.1.
}
  \item{c}{
coefficient used in forced convection (see Blaxter, 1986, default value is 0.24)
}
  \item{n}{
coefficient used in forced convection (see Blaxter, 1986, default value is 0.6)
}
  \item{a}{
coefficient used in free convection (see Gates, 2003. default value is 1)
}
  \item{b}{
coefficient used in free convection (0.58 upright cylinder, 0.48 flat cylinder, default value is 0.58)
}
  \item{m}{
coefficient used in free convection (0.25 laminar flow, default value is 0.25)
}
  \item{type}{
"forced" or "free" - to calculate convection coefficient for either forced or free convection.  Default value is "forced"
}
\item{shape}{
"sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}
\details{
Estimates an area specific rate of heat transfer (W/m2), where a negative value depicts heat loss from surface to air, while positive value depicts heat gain from air to surface.  Uses the gradient in temperature (Ta minus Ts) multiplied by a convection coefficient to estimate heat transfer from a surface.  Designed for estimating steady state heat exchange from animal surfaces using thermal images.
}
\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{hconv}}
}
\examples{
## The function is currently defined as
function (Ts = 30, Ta = 20, V = 1, L = 0.1, c = NULL, n = NULL, a=NULL,
    b = NULL, m = NULL, type = "forced", shape="hcylinder") 
{
    qconv <- (Ta - Ts) * hconv(Ta = 20, V = 1, L = 0.1, c = NULL, n = NULL, a=NULL,
    b = NULL, m = NULL, type = "forced", shape="hcylinder")
    qconv
  }

# Example:
Ts<-30
Ta<-20
V<-1
L<-0.1
type="forced"
shape="hcylinder"

qconv(Ts=Ts, Ta=Ta, V=V, L=L, type=type, shape=shape)

qconv(Ts=Ts, Ta=Ta, V=V, L=L, type=type, shape="sphere")
  
}
