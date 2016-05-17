\name{airviscosity}
\alias{airviscosity}
\title{
Returns air viscovisty for a given air temperature.
}
\description{
Returns the air viscosity value for a given, supplied air temperature (Ta).  Ta should be in
units of oC.
}
\usage{
airviscosity(Ta = 20)
}
\arguments{
  \item{Ta}{
Air temperature in degrees Celsius.  Default value is 20.
}
}

\value{
Kinematic viscosity of air, as a function of temperature
Units: m2/s
Regression for 0 to 100oC range:
Intercept<-13.17380952
Slope<-0.097457143
k<-(Intercept+Slope*Ta)*1e-6 #  multiply by 1e-6 to get into m2/s units
}
\references{
http://www.engineeringtoolbox.com/air-properties-d_156.html
}
\author{
Glenn J Tattersall
}

\examples{

## The function is currently defined as
function (Ta = 20) 
{
    Intercept <- 13.17380952
    Slope <- 0.097457143
    k <- (Intercept + Slope * Ta) * 1e-06
    k
  }
# Example calculation
Ta<-20
airviscosity(Ta)
}
