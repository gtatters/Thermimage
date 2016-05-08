\name{Nusseltfree}
\alias{Nusseltfree}
\title{
Nusselt number for free convection.
}
\description{
Nusselt number for free convection.  Used in calculating heat loss by convection.
}
\usage{
Nusseltfree(b = 0.58, m = 0.25, L = 1, Ts = 20, Ta = 20)
}
\arguments{
  \item{b}{
Coefficient used in calculating Nu. b is 0.58 for upright cylinders, 0.48 for 
horizontal cylinders.  
}
  \item{m}{
Coefficient used in calculating Nu.  m=0.25 for laminar flow.
}
  \item{L}{
Characteristic dimension in metres.
}
  \item{Ts}{
Surface temperature in degrees celsius.  Used in call to Grasshof() function.
}
  \item{Ta}{
Air temperature in degrees celsius.  Used in call to Grasshof() function.
}
}
\references{
Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
}
\author{
Glenn J Tattersall
}
\examples{

## The function is currently defined as
function (b = 0.58, m = 0.25, L = 1, Ts = 20, Ta = 20) 
{
    Nu <- b * Grasshof(L, Ts, Ta)^m
    Nu
  }
}

