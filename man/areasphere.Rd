\name{areasphere}
\alias{areasphere}
\title{
Provides the surface area of a sphere.
}
\description{
Provides the surface area of a sphere.
}
\usage{
areasphere(radius)
}
\arguments{
  \item{radius}{
The radius of the sphere.
}
}
\author{
Glenn J Tattersall
}
\examples{
## The function is currently defined as
function (radius) 
{
    Area <- 4 * pi * radius^2
    Area
  }

# Example calculation:
radius<-4
areasphere(radius)

}

