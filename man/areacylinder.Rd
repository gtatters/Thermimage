\name{areacylinder}
\alias{areacylinder}
\title{
Provides the surface area of a cylinder.
}
\description{
Provides the surface area of a cylinder, including the circular bases.
}
\usage{
areacylinder(Radius, radius=Radius, height, ends = 2)
}
\arguments{
  \item{Radius}{
The major radius of the base of the cylinder.
}
  \item{radius}{
The minor radius of the base of the cylinder.  Default is to equal the major Radius in the case of a circular base.
}
  \item{height}{
The height of the cylinder (alternatively, the length of a horizontal cylinder)
}
  \item{ends}{
How many ends to include in the surface area calculation (2=both ends, 1=one end, 0=neither end)
}
}

\author{
Glenn J Tattersall
}
\examples{
## The function is currently defined as
function(Radius, radius=Radius, height, ends=2)
{
  Area <- (Radius+radius)*pi*height + ends*pi*Radius*radius
  Area
  }

# Example calculation:

# Typically, a body part might be modelled as cylindrical if it appears to be approximately
# circular or elliptical and elongated.  By measuring the major diameter (D) and minor
# diameter (d) as well as the length or height (l), the overall surface area can be 
# determined:

D<-12
d<-6
l<-18
areacylinder(Radius=D/2, radius=d/2, height=l, ends=2)


# To only show surface area of the exposed surface, and exclude the oval base of the 
# cylinder, set ends=0

areacylinder(Radius=D/2, radius=d/2, height=l, ends=0)


}


