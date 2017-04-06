\name{forcedparameters}
\alias{forcedparameters}
\title{
Parameters required for forced convection equation.
}
\description{
Parameters required for forced convection equation and heat exchange estimation.
}
\usage{
forcedparameters(V = 1, L = 0.1, Ta = 20, shape = "hcylinder")
}
\arguments{
  \item{V}{
Air velocity in metres/second.  Used in call to Reynolds().  Default is 0.1.
}
  \item{L}{
Characteristic dimension in metres.  Default value is 0.1.
}
  \item{Ta}{
Air temperature in degrees celsius. Used in call to Reynolds().  Default is 20.
}
  \item{shape}{
"sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}
\details{
Gates (2003) describes coefficients that characterise the base and exponent values used to calculate Nusselt numbers from Reynolds number as: c*Re^n. This function will return those parameters.
}
\value{
A vector of length two, with values c and n.
}
\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.

Gates, DM. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York, 611 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{freeparameters}}
\code{\link{Nusseltforced}}
}
\examples{

## The function is currently defined as
function (V = 1, L = 0.1, Ta = 20, shape = "hcylinder") 
{
    Re <- Reynolds(V, L, airviscosity(Ta))
    if (shape == "vplate" | shape == "hplate") 
        shape <- "plate"
    if (shape == "vcylinder" | shape == "hcylinder") 
        shape <- "cylinder"
    if (shape == "plate") {
        c = 0.595
        n = 0.5
    }
    if (shape == "sphere") {
        c = 0.37
        n = 0.6
    }
    if (shape == "cylinder" & Re >= 0.4 & Re < 4) {
        c <- 0.891
        n = 0.33
    }
    if (shape == "cylinder" & Re >= 4 & Re < 40) {
        c <- 0.821
        n = 0.385
    }
    if (shape == "cylinder" & Re >= 40 & Re < 4000) {
        c <- 0.615
        n = 0.466
    }
    if (shape == "cylinder" & Re >= 4000 & Re < 40000) {
        c <- 0.174
        n = 0.618
    }
    if (shape == "cylinder" & Re >= 40000 & Re < 4e+05) {
        c <- 0.024
        n = 0.805
    }
    coeffs <- c(c, n)
    names(coeffs) <- c("c", "n")
    coeffs
  }
  # Example:
V<-1
L<-0.1
Ta<-20
shape="hcylinder"
forcedparameters(V, L, Ta, shape)

shape="vcylinder"
forcedparameters(V, L, Ta, shape)

shape="hplate"
forcedparameters(V, L, Ta, shape)

shape="vplate"
forcedparameters(V, L, Ta, shape)

shape="sphere"
forcedparameters(V, L, Ta, shape)

}
