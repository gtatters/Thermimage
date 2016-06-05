\name{Nusseltfree}
\alias{Nusseltfree}
\title{
Nusselt number for free convection.
}
\description{
Nusselt number for free convection.  Used in calculating heat loss by convection.
}
\usage{
Nusseltfree(a=NULL, b = NULL, m = NULL, L = 0.1, Ts = 25, Ta = 20, shape="hcylinder")
}
\arguments{
  \item{a}{
Coefficient used in calculating Nu.  a is normally 1, except for turbulent flow.
}
  \item{b}{
Coefficient used in calculating Nu. b is 0.58 for upright cylinders, 0.48 for 
horizontal cylinders.  
}
  \item{m}{
Coefficient used in calculating Nu. m=0.25 for laminar flow.
}
  \item{L}{
Characteristic dimension in metres.
}
  \item{Ts}{
Surface temperature in degrees celsius.  Used in call to Grashof() function.
}
  \item{Ta}{
Air temperature in degrees celsius.  Used in call to Grashof() function.
}
  \item{shape}{
  "sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}
\references{
Blaxter, K. 1989.  Energy Metabolism in Animals and Man
Gates, DM. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York, 611 pp.
}
\author{
Glenn J Tattersall
}
\examples{

## The function is currently defined as
function (a=NULL, b = NULL, m = NULL, L = 0.1, Ts = 20, Ta = 20) 
{
    Nu <- b * (Grashof(L, Ts, Ta)*Prandtl(Ta)^a)^m
    Nu
  }

# Nusselt number for free convection
# Example calculation:

a<-1
b<-0.58
m<-0.25
L<-1
Ts<-30
Ta<-20
Nusseltfree(a,b,m,L,Ts,Ta)


# Free convection is higher when surface temperatures are elevated.  This is the effect
# that free convection predicts: greater molecular energy of air surrounding a warmer surface
# leading to air currents over top of a warm surface.

Ts<-40
Nusseltfree(a,b,m,L,Ts,Ta)




}

