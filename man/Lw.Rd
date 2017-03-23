\name{Lw}
\alias{Lw}
\title{
Estimates downward facing longwave radiation (W/m2) 
}
\description{
Estimates downward facing longwave radiation (W/m2) using a relationship derived from Gabathuler et al 2001
}
\usage{
Lw(Ta = 20, RH = 0.5, n = 0.5)
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
An alternative to Ld() for estimating incoming radiation by determining an offset temperature to account for the influence of atmospheric transmission loss. The incoming infrared radiation is estimated using the Stephan-Boltzmann relationship: 
emissivity*Stephan Boltzmann constant*T^4  
}
\value{
A value, vector of length one, corresponding to the incoming longwave radiation, units: W/m2.
}
\references{
Gabathuler et al 2001.  Parameterization of incoming longwave radiation in high mountain environments.  Physical Geography 22: 99-114
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{Ld}}
}
\examples{

# Example calculation:
Ta<-30
RH<-0.5
n<-0
Lw(Ta, RH, n)

}


