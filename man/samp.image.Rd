\name{samp.image}
\alias{samp.image}
\docType{data}
\title{
A sample thermal image to demonstrate thermal colour palette use.
}
\description{
A sample thermal image to demonstrate thermal colour palette use.
}
\usage{data("samp.image")}
\format{
A sample thermal image to demonstrate thermal colour palette use.

The format is: num [1:480, 1:640] 25.4 25.4 25.4 25.4 25.4 ...
}
\examples{
### To load image
data(samp.image)

###### Example #####
palnames<-c("flir", "ironbow", "mikronprism", "glowbow", "grey120", "grey10", "greyred", 
"hotiron",  "medical", "midgreen", "midgrey", "mikroscan", "yellowpal", "rainbowpal")

#par(mfrow=c(length(palnames),1),mar=c(0.3,4,0.3,4))
data(samp.image)
r<-rotate90.matrix(samp.image)

## Show palettes
for(i in 1:length(palnames))
{
    par(pin=c(4,3))
    image(r, useRaster=TRUE, axes=FALSE, col=palette.choose(palnames[i]),main=palnames[i])
}



}
\keyword{datasets}
