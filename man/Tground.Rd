\name{Tground}
\alias{Tground}
\title{
Estimates ground temperature from ambient temperature and solar radiation.
}
\description{
Estimates ground temperature from ambient temperature and solar radiation.
}
\usage{
Tground(Ta = 20, SE = 100)
}
\arguments{
  \item{Ta}{
Air temperature (degrees Celsius).  Default is 20.
}
  \item{SE}{
Solar energy (radiation in W per m2).  Default is 100.
}
}
\details{
If ground temperature is not measured, but air temperature and solar energy are provided, ground temperature can be estimated from empirical relationships.  Ground temperature is used in obtain incoming longwave radiation from the ground.
}
\value{
Returns a vector of one, with an estimate of ground temperature.
}
\references{
Bartlett et al. 2006. A decade of ground-air temperature tracking at emigrant pass observatory, Utah. Journal of Climate. 19: 3722-3731.
}
\author{
Glenn J Tattersall
}
\examples{
## The function is currently defined as
function (Ta = 20, SE = 100) 
{
    Tground <- 0.0121 * SE + Ta
    names(Tground) <- "Tground"
    Tground
  }
  
# Example:
Ta<-25
SE<-200
Tground(Ta, SE)
  
}

