\name{Prandtl}
\alias{Prandtl}
\title{
Returns the Prandtl number
}
\description{
Returns the Prandtl number
}
\usage{
Prandtl(Ta = 20)
}
\arguments{
  \item{Ta}{
Air temperature in degrees Celsius.  Default value is 20.
}
}
\details{
Returns the Prandlt number
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
function (Ta = 20) 
{
    Temp <- c(-50, -25, 0, 20, 40, 60, 80, 90, 100)
    Pr <- c(0.725, 0.72, 0.715, 0.713, 0.711, 0.709, 0.707, 0.7055, 
        0.703)
    lm <- lm(Pr ~ poly(Temp, 6))
    Prandtl <- predict(lm, newdata = data.frame(Temp = Ta), interval = "none")
    names(Prandtl) <- NULL
    Prandtl
  }

# Example:
Ta<-30
Prandtl(Ta)

}
