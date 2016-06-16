\name{airdensity}
\alias{airdensity}
\title{
Returns the density of air for a given air temperature.
}
\description{
Density of air if temperature (degrees Celsius) provided.  Units: kg/m3
}
\usage{
airdensity(Ta = 20)
}

\arguments{
  \item{Ta}{
Air temperature in degrees Celsius.  Default value is 20.
}
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
    Base <- 314.156
    Exponent <- (-0.981)
    p <- Base * (Ta + 273.15)^Exponent
    p
  }
}
