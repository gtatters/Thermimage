\name{qrad}
\alias{qrad}
\title{
Estimates the area specific heat transfer by radiation (W/m2)
}
\description{
Estimates heat transfer by radiation (W/m2), using the absorbed radiation estimate from qabs() minus emitted radiation from the object surface (determined from thermal image surface temperature estimates).  Positive value = heat gain from environment to object.  Negative value = heat loss from object to environment.
}
\usage{
qrad(Ts = 30, Ta = 25, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 0)
}

\arguments{
  \item{Ts}{
Surface temperature (degrees Celsius) of the object.  Default value is 30.
}
  \item{Ta}{
Air temperature (degrees Celsius), or effective atmospheric temperature.  Default value is 25.
}
  \item{Tg}{
Ground temperature (degrees Celsius) to estimate longwave ground radiation.  Default value is NULL, since Tg can be estimated from Ta unless otherwise measured.
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
}
\details{
Total solar radiation must be supplied at this stage.  The calculation here provides the worst case scenario since since no profile/angle metrics are yet taken into account.  The animal could change orientation to/away from solar beam.  
}

\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{Ld}}
\code{\link{Lu}}
\code{\link{Ld}}
\code{\link{qabs}}
}
\examples{

## The function is currently defined as
function (Ts = 30, Ta = 25, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, 
    cloud = 0, SE = 0) 
{
    qrad <- qabs(Ta = Ta, Tg = Tg, RH = RH, E = E, rho = rho, 
        cloud = cloud, SE = SE) - E * StephBoltz() * (Ts + 273.15)^4
    qrad
  }

# Example:
Ts<-30
Ta<-25
Tg<-28
RH<-0.5
E<-0.96
rho<-0.1
cloud<-0
SE<-100
# qrad should result in a positive gain of heat:
qrad(Ts, Ta, Tg, RH, E, rho, cloud, SE)

# if rho is elevated (i.e. doubles reflectance of solar energy), heat exchange by 
# radiation is reduced
rho<-0.2
qrad(Ts, Ta, Tg, RH, E, rho, cloud, SE)

# But if solar energy = 0, under similar conditions, qrad is negative:
SE<-0
qrad(Ts, Ta, Tg, RH, E, rho, cloud, SE)




}
