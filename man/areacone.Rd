\name{areacone}
\alias{areacone}
\title{
Provides the surface are of a cone
}
\description{
Provides the surface area of a cone with an elliptical base.  For a circular cone, simply use Radius=radius.
}
\usage{
areacone(Radius, radius=Radius, hypotenuse=NULL, height, ends=1)
}
\arguments{
  \item{Radius}{
The Radius of the major axis of the base of the cone. 
}
 \item{radius}{
The radius of the minor axis of the base of the cone. 
}
  \item{hypotenuse}{
The hypotenuse of the height of the cone (if blank, determined from radius and height)
}
  \item{height}{
The height of the cone (if hypotenuse is known, leave height blank)
}
  \item{ends}{
To include the base area in surface area calculation, set ends = 1, otherwise set ends = 0.
}
}
\details{
Calculates the surface are of a cone with an elliptical base.
}

\author{
Glenn J Tattersall
}

\examples{

## The function is currently defined as
function(Radius, radius=Radius, hypotenuse=NULL, height, ends=1)
{
  if(is.null(hypotenuse)){
    hypotenuse<-sqrt(height^2+Radius^2)
  }
  Area <- ends*pi*Radius*radius + pi*Radius*hypotenuse
  Area
}

# Example calculation from a measure of a bird bill.

# Typically, a bird bill will be measured by its depth (d) at the base, its width (w) at the 
# base and by its overall length.  The length (l) is typically measured along the length of
# the culmen, and thus is a diagonal measure along the hypotenuse of the cone.

d<-12
w<-6
l<-18
areacone(Radius=d/2, radius=w/2, hypotenuse=l, height=NULL, ends=1)


# If the perpendicular cone height (h) is instead measured, rather than the hypotenuse, then
# substitute h for height and assign hypotenuse = NULL, to obtain the same result

h<-sqrt(l^2-(d/2)^2)
areacone(Radius=d/2, radius=w/2, hypotenuse=NULL, height=h, ends=1)


# To only show surface area of the exposed surface, and exclude the oval base of the cone
# set ends=0:

areacone(Radius=d/2, radius=w/2, hypotenuse=l/2, height=NULL, ends=0)

}
