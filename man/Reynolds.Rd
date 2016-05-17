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
Blaxter, K. 1989.  Energy Metabolism in Animals and Man
Gates, D. M. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York.  611 pp.
}
\author{
Glenn J Tattersall
}
\examples{
## The function is currently defined as
function (V, L, v) 
{
  v<-airviscosity(Ta)
  Re<-V*L/v
  }

# Typical values for Reynolds numbers range from 6.6 to 6.6e+5 

# Example calculation:
V<-1
L<-1
Ta<-20
v<-airviscosity(Ta)
Reynolds(V, L, v)

}
