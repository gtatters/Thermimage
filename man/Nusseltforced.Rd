\name{Nusseltforced}
\alias{Nusseltforced}
\title{
Nusselt number for forced convection.
}
\description{
Nusselt number for forced convection.  Used in estimating convective heat loss.
}
\usage{
Nusseltforced(a = 0.24, n = 0.6, V = 1, L = 1, Ta = 20)
}
\arguments{
  \item{a}{
coefficient used in calculating Nusselt number
}
  \item{n}{
coefficient used in calculating Nusselt number
}
  \item{V}{
Air velocity in metres/second.  Used in call to Reynolds()
}
  \item{L}{
Characteristic dimension in metres.  
}
  \item{Ta}{
Air temperature in degrees celsius. Used in call to Reynolds().
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
function (a = 0.24, n = 0.6, V = 1, L = 1, Ta = 20) 
{
    Nu <- a * Reynolds(V, L, Ta)^n
    Nu
  }
}

