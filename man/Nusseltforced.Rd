\name{Nusseltforced}
\alias{Nusseltforced}
\title{
Nusselt number for forced convection.
}
\description{
Nusselt number for forced convection.  Used in estimating convective heat loss.  Typical values of c and n are 0.24 and 0.6, respectively.  This function sets c and n to NULL to force shape calculation checks.
}
\usage{
Nusseltforced(c = NULL, n = NULL, V = 1, L = 0.1, Ta = 20, shape="hcylinder")
}
\arguments{
  \item{c}{
coefficient used in calculating Nusselt number.  Default is NULL
}
  \item{n}{
coefficient used in calculating Nusselt number. Default is NULL
}
  \item{V}{
Air velocity in metres/second.  Used in call to Reynolds().  Default value is 1.
}
  \item{L}{
Characteristic dimension in metres.  Default value is 0.1.
}
  \item{Ta}{
Air temperature in degrees celsius. Used in call to Reynolds().
}
\item{shape}{
"sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}

\references{
Gates, DM. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York, 611 pp.
Blaxter, K. 1989.  Energy Metabolism in Animals and Man
}
\author{
Glenn J Tattersall
}
\examples{

## The function is currently defined as
function (c = NULL, n = NULL, V = 1, L = 0.1, Ta = 20, shape="hcylinder") 
{
    Nu <- c * Reynolds(V, L, Ta)^n
    Nu
  }
  
# Example
# Usually called from the hconv() or qconv() functions
V<-1
L<-0.1
Ta<-20
shape="hcylinder"

Nu<-Nusseltforced(V=V, L=L, Ta=Ta, shape=shape)

}

