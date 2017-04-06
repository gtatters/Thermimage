\name{airspecificheat}
\alias{airspecificheat}
\title{
Specific heat capacity of air
}
\description{
Specific heat capacity of air if temperature (degrees Celsius) provided.  Units: J/(kg*K)
}
\usage{
airspecificheat(Ta = 20)
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
    Intercept <- 1.003731424
    Slope1 <- 5.37909e-06
    Slope2 <- 7.30124e-07
    Slope3 <- (-1.34472e-09)
    Slope4 <- 1.23027e-12
    cp <- 1000*(Intercept + Slope1 * Ta + Slope2 * Ta^2 + Slope3 * 
        Ta^3 + Slope4 * Ta^4)
    cp
  }
}
