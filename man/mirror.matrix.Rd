\name{mirror.matrix}
\alias{mirror.matrix}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Mirrors a matrix upside-down.  Used in re-arranging image data for plotting properly in R.
}
\description{
Mirrors a matrix upside-down.  Used in re-arranging image data for plotting properly in R.
}
\usage{
mirror.matrix(x)
}
\arguments{
  \item{x}{
A matrix corresponding to raster or image data.
}
}
\value{
Returns a matrix
}
\author{
Glenn J Tattersall
}
\seealso{
\code{\link{flip.matrix}}
\code{\link{rotate90.matrix}}
\code{\link{rotate270.matrix}}
\code{\link{rotate180.matrix}}
}
\examples{

## The function is currently defined as
function (x) 
{
    xx <- as.data.frame(x)
    xx <- rev(xx)
    xx <- as.matrix(xx)
    xx
  }
  

# flir<-palette.choose("flir")
# par(mfrow=c(2,1),mar=c(1,1,1,1))
# r<-c(1:100,rnorm(1:100)*10,1:100)
# m<-matrix(r,50)
# image(m, axes=FALSE, col=flir)
# box()
# text(.5,.5,"Matrix",col="white")
# mf<-mirror.matrix(m)
# image(mf,axes=FALSE,col=flir)
# box()
# text(.5,.5,"Mirror",col="white")
}

