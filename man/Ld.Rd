\name{Ld}
\alias{Ld}
\title{
Estimates downward facing longwave radiation (W/m2) 
}
\description{
Estimates downward incoming longwave radiation (W/m2) using relationship derived from Konzelmann et al. 1994.   
}
\usage{
Ld(Ta = 20, RH = 0.5, n = 0.5)
}
\arguments{
  \item{Ta}{
Local air temperature (degrees Celsius), ~ 2 m above ground 
}
  \item{RH}{
Local relative humidity (fractional value from 0 to 1)
}
  \item{n}{
Fractional cloud cover (fractional value from 0 to 1)
}
}
\details{
By estimating the sky emissivity, from information on humidity and cloud cover, the incoming infrared radiation can be estimated using the Stephan-Boltzmann relationship: emissivity*Stephan Boltzmann constant * T^4. 
The effective atmospheric emissivity is determined from known cloud emissivity (0.97) and empirically determined clear sky emissivities.
}

\value{
A value, vector of length one, corresponding to the incoming longwave radiation, units: W/m2.
}

\references{
Konzelmann et al 1994.  Parameterization of global and longwave incoming radiation for the Greenland ice-sheet.  Global and Planetary Change.  9: 143-164. 
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{Lw}}
}
\examples{

# Returns a value in W/m2 of the estimated incoming longwave radiation  
# Example calculation:

Ta<-30
RH<-0.5
n<-0
Ld(Ta, RH, n)

}


