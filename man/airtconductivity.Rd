\name{airtconductivity}
\alias{airtconductivity}
\title{
Thermal conductivity of air.
}
\description{
Thermal conductivity of air.  Units: W/m/K
}
\usage{
airtconductivity(Ta = 20)
}

\arguments{
  \item{Ta}{
Air temperature in degrees Celsius.
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
    Intercept <- 0.024280952
    Slope <- 7.07143e-05
    k <- Intercept + Slope * Ta
    k
  }
}
