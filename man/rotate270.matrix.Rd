\name{rotate270.matrix}
\alias{rotate270.matrix}
\title{
Rotate a matrix by 270 degrees counterclockwise (or 90 degree clockwise).  Used for adjusting image plotting in R.
}
\description{
Rotate a matrix by 270 degrees counterclockwise (or 90 degree clockwise).  Used for adjusting image plotting in R.
}
\usage{
rotate270.matrix(x)
}
\arguments{
  \item{x}{
A matrix corresponding to raster or image data.
}
}
\value{
Returns a matrix
}
\references{
1. http://www.inside-r.org/packages/cran/RSEIS/docs/mirror.matrix

2. Based on similar code in package <RSEIS>
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{flip.matrix}}
\code{\link{mirror.matrix}}
\code{\link{rotate90.matrix}}
\code{\link{rotate180.matrix}}
}
\examples{

## The function is currently defined as
function (x) 
{
    mirror.matrix(t(x))
  }
  
  
# Example
flir<-palette.choose("flir")
set.seed(5)
par(mfrow=c(1,2),mar=c(1,1,1,1))
r<-c(1:100,rnorm(1:100)*10,1:100)
m<-matrix(r,50)
image(m, axes=FALSE, col=flir)
box()
text(.5,.5,"Matrix",col="white")
mf<-rotate270.matrix(m)
image(mf,axes=FALSE,col=flir)
box()
text(.5,.5,"Rotate270",col="white")
  
}

