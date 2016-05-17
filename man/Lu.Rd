\name{Lu}
\alias{Lu}
\title{
Estimates upward facing ground radiation (W/m2)
}
\description{
Estimates upward facing ground radiation (W/m2), from the Stephan Boltzmann relationship and ground temperature
}
\usage{
Lu(Tg = 20, Eground = 0.97)
}
\arguments{
  \item{Tg}{
Ground temperature (degrees celsius)
}
  \item{Eground}{
Emissivity of soil or ground.  Default value is 0.97.  
}
}
\details{
Calculates ground radiation facing upward.  Assumes ground emissivity = 0.97.  Terrain emissivities vary from 0.89 (sand, snow) to 0.97 (moist soil) - Blaxter, 1986
}
\value{
A value, vector of length one, corresponding to the longwave radiation from the ground, units: W/m2.
}
\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{Ld}}
}
\examples{
## The function is currently defined as
function (Tg = 20, Eground = 0.97) 
{
    GT <- Tg + 273.15
    Lu <- Eground * StephBoltz() * (GT)^4
    Lu
  }

# Estimates ground generated longwave radiation rising up.  Units W/m2.
# Example calculation:
Tg<-30
Eground<-0.97
Lu(Tg, Eground)
}

