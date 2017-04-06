\name{Teq}
\alias{Teq}
\title{
Estimates equivalent temperature.
}
\description{
Estimates equivalent black-body temperature of an object.  Analagous to other measures of operative temperature
}
\usage{
Teq(Ts = 30, Ta = 25, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 0, V = 1, 
L = 0.1, type = "forced")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Ts}{
Surface temperature (degrees Celsius). Default value is 30.  Not used in this calculation but kept for similar structure to other functions in package.
  }
  \item{Ta}{
Air temperature (degrees Celsius).  Default value is 20.  Used to estimate ground temperature if Tg is unavailable.
}
  \item{Tg}{
Ground temperature (degrees Celsius).  Default value is NULL, but a measured Tg can be substituted or estimated with other functions.  Used in estimating long wave radiation from the ground.
}
  \item{RH}{
Relative humidity (fraction 0 to 1).  Default value is 0.5.  Used in call to Ld() to determine incoming radiation.
}
  \item{E}{
Emissivity (fraction 0 to 1) of the object absorbing longwave radiation.  According to Kirschoff's law, emissivity = absorptivity.  Absorptivity is multiplied by the average of the incoming longwave radiation to estimate absorbed radiation.
}
  \item{rho}{
Reflectivity (fraction 0 to 1) of the object absorbing solar radiation.  Used to modify absorbed solar energy.  Default is 0.1.  
}
  \item{cloud}{
Fractional cloud cover (fraction from 0 to 1).  Used in call to Ld() to determine incoming radiation.  Default is 0.
}
  \item{SE}{
Solar energy (W/m2), usually measured.  Default is 100.
}
 \item{V}{
Air velocity (m/s).  Default value is 1.
}
  \item{L}{
Characteristic dimension (m) of object.  Usually the vertical dimension (i.e. height). Default value is 1.
}
\item{type}{
"forced" or "free" - to calculate convection coefficient for either forced or free convection.  Default value is "forced"
}
}
\references{
Mahoney, S.A. and King, J. R. (1977). The use of the equivalent black-body temperautre in the thermal energetics of small birds.  J Thermal Biol. 2: 115-120
}
\author{
Glenn J Tattersall
}
\examples{
## The function is currently defined as
function (Ts = 30, Ta = 25, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, 
    cloud = 0, SE = 0, V = 1, L = 0.1, type = "forced") 
{
    if (type == "forced") 
        k <- 0.7 * 310
    if (type == "free") 
        k <- 310
    rr <- airdensity(Ta) * airspecificheat(Ta)/(4 * E * StephBoltz() * 
        (Ta + 273.15)^3)
    ra <- k * (L/V)^0.5
    re <- 1/(1/ra + 1/rr)
    Rni <- qabs(Ta = Ta, Tg = Tg, RH = RH, E = E, rho = rho, 
        cloud = cloud, SE = SE) - StephBoltz() * E * (Ta + 273.15)^4
    Teq <- Ta + Rni * re/(airdensity(Ta) * airspecificheat(Ta))
    Teq
  }
}
