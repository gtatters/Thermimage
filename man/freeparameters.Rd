\name{freeparameters}
\alias{freeparameters}
\title{
Parameters required for free convection equation.
}
\description{
Parameters required for free convection equation and heat exchange estimation.
}
\usage{
freeparameters(L = 0.1, Ts = 30, Ta = 20, shape = "hcylinder")
}
\arguments{
  \item{L}{
Characteristic dimension in metres.  Default is 0.1.
}
  \item{Ts}{
Surface temperature (degrees Celsius) of object.  Default is 30.
}
  \item{Ta}{
Air temperature (degrees Celsius) of environment.  Defauly is 20.
}
  \item{shape}{
 "sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder".
}
}
\details{
Gates (2003) describes coefficients that characterise laminar flow patterns describing how to calculate Nusselt numbers for objects of different shapes.  This function will return those parameters.  At present, it only supplies coefficients for different shapes, not for laminar vs. turbulent since free convection is not often used in biological applications.
}
\value{
A vector of length three, with values a, b, and m.
}
\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.

Gates, DM. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York, 611 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{Nusseltfree}}
\code{\link{forcedparameters}}
}
\examples{
## The function is currently defined as
function (L = 0.1, Ts = 30, Ta = 20, shape = "hcylinder") 
{
    a = 1
    Gr <- Grashof(L = 1, Ts = Ts, Ta = Ta)
    Pr <- Prandtl(Ta)
    if (shape == "hcylinder") {
        b <- 0.53
        m <- 0.25
    }
    if (shape == "vcylinder") {
        b <- 0.726
        m <- 0.25
    }
    if (shape == "hplate") {
        b <- 0.71
        m <- 0.25
    }
    if (shape == "vplate") {
        b <- 0.523
        m <- 0.25
    }
    if (shape == "sphere") {
        b <- 0.58
        m <- 0.25
    }
    coeffs <- c(a, b, m)
    names(coeffs) <- c("a", "b", "m")
    coeffs
  }

# Example:
L<-0.1
Ts<-30
Ta<-20
shape="hcylinder"
freeparameters(L, Ts, Ta, shape)

shape="vcylinder"
freeparameters(L, Ts, Ta, shape)

shape="hplate"
freeparameters(L, Ts, Ta, shape)

shape="vplate"
freeparameters(L, Ts, Ta, shape)

shape="sphere"
freeparameters(L, Ts, Ta, shape)

}
