\name{qabs}
\alias{qabs}
\title{
Estimates the absorbed solar and infrared radiation (W/m2)
}
\description{
Estimates the absorbed solar radiation and infrared radiation (W/m2) of an object using known physical relationships. 
}
\usage{
qabs(Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 100)
}
\arguments{
  \item{Ta}{
Air temperature (degrees Celsius).  Default value is 20.  Used to estimate ground temperature if Tg is unavailable.
}
  \item{Tg}{
Ground temperature (degrees Celsius).  Default value is NULL, but a measured Tg can be substituted or estimated with other functions.
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
\code{\link{qrad}}
}
\examples{
## The function is currently defined as
function (Ta = 25, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, 
    cloud = 0, SE = 100) 
{
    if (length(SE) == 1) 
        SE <- rep(SE, length(Ta))
    if (is.null(Tg)) 
        Tg <- Tg(Ta, SE)
    Ld <- Ld(Ta, RH = RH, n = cloud)
    Lu <- Lu(Tg)
    IR <- E * (Lu + Ld)/2
    qabs <- (1 - rho) * SE + IR
    qabs
  }
  
# Example:
Ta<-25
Tg<-30
RH<-0.5
E<-0.96
rho<-0.1
cloud=0
SE<-100
qabs(Ta, Tg, RH, E, rho, cloud, SE)

# If Tg is unknown it can be set to NULL, and the qabs function will estimate Tg from
# an empirical relationship of Tg vs Ta and SE from the Tground() function

qabs(Ta, Tg=NULL, RH, E, rho, cloud, SE)

# For detailed examples and explanations, see:
https://github.com/gtatters/Thermimage/blob/master/HeatTransferCalculations.md
  
}
