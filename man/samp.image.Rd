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
  The format is:
 num [1:480, 1:640] 23.2 23.2 23.4 23.3 23.3 ...
}
\examples{
###### Example #####
palnames<-c("flir", "ironbow", "mikronprism", "glowbow", "grey120", "grey10", "greyred", 
"hotiron",  "medical", "midgreen", "midgrey", "mikroscan", "yellowpal", "rainbowpal")

m<-rotate90.matrix(samp.image)
par(mfrow=c(2,1),mar=c(0.3,2,1,2), pin=c(3,2.25))

## Show palettes
image(m, axes=FALSE, useRaster=TRUE, col=flirpal, main="Flir Standard Palette")
image(m, axes=FALSE, useRaster=TRUE, col=ironbowpal, main="Ironbow Palette") 
# smaller palette for faster plotting
image(m, axes=FALSE, useRaster=TRUE, col=mikronprismpal, main="Mikron Prism Palette")
image(m, axes=FALSE, useRaster=TRUE, col=glowbowpal, main="Glowbow Palette")
image(m, axes=FALSE, useRaster=TRUE, col=grey120pal, main="Grey120 Palette")
image(m, axes=FALSE, useRaster=TRUE, col=grey10pal, main="Grey10 Palette")
image(m, axes=FALSE, useRaster=TRUE, col=greyredpal, main="Greyred Palette")
image(m, axes=FALSE, useRaster=TRUE, col=hotironpal, main="Hotiron Palette")
image(m, axes=FALSE, useRaster=TRUE, col=medicalpal, main="Medical Palette")
image(m, axes=FALSE, useRaster=TRUE, col=midgreypal, main="Midgrey Palette")
image(m, axes=FALSE, useRaster=TRUE, col=mikroscanpal, main="Mikroscan Palette")
image(m, axes=FALSE, useRaster=TRUE, col=rainbowpal, main="Rainbow Palette")
image(m, axes=FALSE, useRaster=TRUE, col=yellowpal, main="Yellow Palette")

}
\keyword{datasets}
