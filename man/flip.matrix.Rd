\name{flip.matrix}
\alias{flip.matrix}
\title{
Flips a matrix 'left-right'.  Used in re-arranging image data for plotting properly in R.
}
\description{
Flips a matrix 'left-right'.  Used in re-arranging image data for plotting properly in R.
}
\usage{
flip.matrix(x)
}
\arguments{
  \item{x}{
A matrix corresponding to raster or image data.
}
}

\author{
Glenn J Tattersall
}
\references{
1. http://www.inside-r.org/packages/cran/RSEIS/docs/mirror.matrix

2. Based on similar code in package <RSEIS>
}
\seealso{
\code{\link{mirror.matrix}}
\code{\link{rotate90.matrix}}
\code{\link{rotate270.matrix}}
\code{\link{rotate180.matrix}}
}
\examples{
## The function is currently defined as
function (x) 
{
    mirror.matrix(rotate180.matrix(x))
  }


par(mfrow=c(1,2),mar=c(1,1,1,1))
r<-c(1:100,rnorm(1:100)*10,1:100)
m<-matrix(r,20)
image(m, axes=FALSE)
box()
text(.5,.5,"Matrix",col="white")
mf<-flip.matrix(m)
image(mf,axes=FALSE)
box()
text(.5,.5,"Flipped",col="white")
  
}
