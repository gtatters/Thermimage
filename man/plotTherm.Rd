\name{plotTherm}
\alias{plotTherm}
\title{
Plot thermal image data for visualisation purposes.
}
\description{
A quick way to plot and visualise thermal image data using the fields package image.plot function.  
}
\usage{
plotTherm(bindata, templookup = NULL, w, h, minrangeset = 20, maxrangeset = 40, trans="I",
main = NULL, thermal.palette = flirpal)
}
\arguments{
  \item{bindata}{
An integer vector of raw binary thermal information (usually) extracted from a thermal video or image using the getFrames or readflirJPG functions to be converted to temperature and summarised.  Instead, this can be a vector of temperature values (numeric); if so, then templookup should be set to NULL or ignored.
}
  \item{templookup}{
A vector of temperatures converted using the raw2temp function, corresponding to the conversion from raw binary thermal information to calibrated temperature estimates.  Typically will be vector of numbers 2^16 long, for a 16-bit camera.  Default is NULL, which assumes that dat has already been converted to temperature.
}
  \item{w}{
Width resolution (pixels) of thermal camera.  Can be found by using the flirsettings function.
}
  \item{h}{
Height resolution (pixels) of thermal camera.  Can be found by using the flirsettings function.
}

  \item{minrangeset}{
The minimum temperature to scale the raster plot z (temperature) value to.
}
  \item{maxrangeset}{
The maximum temperature to scale the raster plot z (temperature) value to.
}
  \item{trans}{
Transformation to apply to image matrix.  Default is I, the identity matrix, which will plot the image without transformation.  Options are mirror.matrix, rotate90.matrix, rotate270.matrix, rotate180.matrix, flip.matrix.
}
  \item{main}{
Title to plot on image.  Default is NULL.
}
  
  \item{thermal.palette}{
Palette to use for the thermal image plot.  Default is ironbowpal (FLIR standard prism palette).  See examples in the palette.choose() function, or provide a custom palette.   

Experience has shown that it is challenging to set the scale bar to align nicely with the rasterised image, so the user is left to explore the image.plot() function on their own.  It may help to set the plot area size first to get nicely aligned image and scale bars.  The following option has worked in testing: par(pin=c(6,4.5))
}
  
}
\details{
This function is a simplified wrapper to call the image.plot function in the fields package.  Not all options are implemented, but default ones are shown here.  
}
\value{
Provides a rasterised plot based on a vector of data from a thermal image file.
}
\references{
Douglas Nychka, Reinhard Furrer, John Paige and Stephan Sain (2015). "fields: Tools for spatial data."
doi: 10.5065/D6W957CT (URL: http://doi.org/10.5065/D6W957CT), R package version 8.10, <URL: www.image.ucar.edu/fields>.
}
\author{
Glenn J Tattersall
}

\examples{

m = 400 # grid size
C = complex( real=rep(seq(-1.8,0.6, length.out=m), each=m ), 
imag=rep(seq(-1.2,1.2, length.out=m), m ) )
C = matrix(C,m,m)

Z = 0
X = array(0, c(m,m,20))

for (k in 1:10) {
  Z = Z^2+C
  X[,,k] = exp(-abs(Z))
}

for (k in 1:10){
  x<-as.matrix(X[,,k], nrow=400)
  x[is.na(x)]<-min(x, na.rm=TRUE)
  plotTherm(x, w=400, h=400, minrangeset=min(x), maxrangeset=max(x))
}


# set w to 640 and h to 480
w<-640
h<-480
f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)
suppressWarnings(templookup<-raw2temp(1:65535))
alldata<-unlist(lapply(x$f.start, getFrames, vidfile=f, w=w, h=h))
alldata<-matrix(alldata, nrow=w*h, byrow=FALSE)
alltemperature<-templookup[alldata]
alltemperature<-unname(matrix(alltemperature, nrow=w*h, byrow=FALSE))

# Plot 
plotTherm(alldata[,2], templookup=templookup, w=w, h=h,  minrangeset=min(alldata),
          maxrangeset=max(alldata), trans="mirror.matrix")


# Plot all frames using binary data with templookup
x<-apply(alldata, 2, plotTherm, templookup=templookup, w=w, h=h, minrangeset=20, 
maxrangeset=40, trans="mirror.matrix")

# Plot all frames using converted temperature data
x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
         maxrangeset=max(alltemperature), thermal.palette=flirpal, trans="mirror.matrix")

# Try other palettes:
#x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
#maxrangeset=max(alltemperature), thermal.palette=rainbowpal, trans="mirror.matrix")

#x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
#maxrangeset=max(alltemperature), thermal.palette=midgreypal, trans="mirror.matrix")

#x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
#maxrangeset=max(alltemperature), thermal.palette=midgreenpal, trans="mirror.matrix")

#x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
#maxrangeset=max(alltemperature), thermal.palette=greyredpal, trans="mirror.matrix")

#x<-apply(alltemperature, 2, plotTherm, w=w, h=h, minrangeset=min(alltemperature),
#maxrangeset=max(alltemperature), thermal.palette=hotironpal, trans="mirror.matrix")


}

