\name{Reynolds}
\alias{Reynolds}
\title{
Calculates the Reynolds number.
}
\description{
Calculates the Reynolds number, a unitless measure.
}
\usage{
Reynolds(V, L, v)
}
\arguments{
  \item{V}{
Air velocity in m/s
}
  \item{L}{
The characteristic dimension, usually the vertical dimension.  For reference, 
a cylinder's characteristic L would be its height, assuming it is standing on its end
This L should be the same L as is used for the convective coefficient calculation
}
  \item{v}{
The kinematic viscosity returned from function airviscosity (Ta).
}
}
\references{
Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
}
\author{
Glenn J Tattersall
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (V, L, v) 
{
  v<-airviscosity(Ta)
  Re<-V*L/v
  }
}
