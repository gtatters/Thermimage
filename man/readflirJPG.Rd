\name{readflirJPG}
\alias{readflirJPG}
\title{
Reads an image from a FLIR JPG file into an integer array.
}
\description{
Reads an image from a FLIR JPG file into an integer matrix, w pixels wide x h pixels high, depending on image size.
}
\usage{
readflirJPG(imagefile, exiftool = "installed")
}
\arguments{
  \item{imagefile}{
Name of the FLIR JPG file to read from, as captured by the thermal camera.  A character string.
}
  \item{exiftool}{
determines whether Exiftool has been "installed" (http://www.sno.phy.queensu.ca/~phil/exiftool/) or not.  If "package" is used (currently experimental), an internal perl script included with this package will be called.  A character string. 
}
}
\details{
Only tested on a select number of FLIR JPGs.  Usage depends on functionality provided by Exiftool.
}
\value{
Returns a matrix of integer values, corresponding the calibrated raw thermal image radiance values.  Can be converted to temperature estimates using the raw2temp() function.
}
\references{
1. Exiftool Command line tool: http://www.sno.phy.queensu.ca/~phil/exiftool/

2. Simon Urbanek (2013). tiff: Read and write TIFF images. R package version
  0.1-5. https://CRAN.R-project.org/package=tiff
  
3.  Simon Urbanek (2013). png: Read and write PNG images. R package version 0.1-7.
  https://CRAN.R-project.org/package=png
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{temp2raw}}
\code{\link{raw2temp}}
}
\examples{
# Examples 
# Sample flir jpg included with Thermimage package:

imagefile<-paste0(system.file("extdata/IR_2412.jpg", package="Thermimage"))

# Extract meta-tags from thermal image file ##
cams<-flirsettings(imagefile, exiftool="installed", camvals="")
cams

# Set variables for calculation of temperature values from raw A/D sensor data  ####
Emissivity<-cams$Info$Emissivity      # Image Saved Emissivity - should be ~0.95 or 0.96
ObjectEmissivity<-0.96                # Object Emissivity - should be ~0.95 or 0.96
dateOriginal<-cams$Dates$DateTimeOriginal
dateModif<-   cams$Dates$FileModificationDateTime
PlanckR1<-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
PlanckB<-     cams$Info$PlanckB                       # Planck B constant for camera  
PlanckF<-     cams$Info$PlanckF                       # Planck F constant for camera
PlanckO<-     cams$Info$PlanckO                       # Planck O constant for camera
PlanckR2<-    cams$Info$PlanckR2                      # Planck R2 constant for camera
OD<-          cams$Info$ObjectDistance                # object distance in metres
FD<-          cams$Info$FocusDistance                 # focus distance in metres
ReflT<-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
AtmosT<-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
IRWinT<-      cams$Info$IRWindowTemperature           # IR Window Temperature
IRWinTran<-   cams$Info$IRWindowTransmission          # IR Window transparency
RH<-          cams$Info$RelativeHumidity              # Relative Humidity
h<-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
w<-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

### Import image from flir jpg to obtain binary data
img<-readflirJPG(imagefile, exiftool="installed")

# Rotate image before plotting
imgr<-rotate270.matrix(img)

# Plot initial image of raw binary data
fields::image.plot(imgr, useRaster=TRUE, col=ironbowpal)

# Convert binary data to temperature ####

# Consider whether you should change any of the following: 
# ObjectEmissivity, OD, RH, ReflT, AtmosT, IRWinT, IRWinTran

temperature<-raw2temp(imgr,ObjectEmissivity,OD,ReflT,AtmosT,IRWinT,IRWinTran,RH,
                      PlanckR1,PlanckB,PlanckF,PlanckO,PlanckR2)
colnames(temperature)<-NULL
rownames(temperature)<-NULL

# Plot temperature image using fields package
t<-temperature
fields::image.plot(t, asp=h/w, bty="n", useRaster=TRUE, xaxt="n", yaxt="n", col=ironbowpal)

# Plot temperature image using ggplot2
library(ggplot2)
library(reshape2)
d<-reshape2::melt(temperature)

p<-ggplot2::ggplot(d, aes(Var1, Var2))+
geom_raster(aes(fill=value))+coord_fixed()+
  scale_fill_gradientn(colours=ironbowpal)+
  theme_void()+
  theme(legend.key.height=unit(2, "cm"), legend.key.width=unit(0.5, "cm"))
 p


# Export Temperature Data to CSV file ####
# Must rotate image 90 degrees before exporting
# This csv file can be imported into imageJ (File-Import-Text Image) for open source image
# analysis options of accurate thermal image data.  If you have many csv files, consider
# writing a macro, see:
# http://imagej.1557.x6.nabble.com/open-text-image-sequence-td4999149.html


f.temperature<-"IR_2412.csv"
write.csv(rotate90.matrix(temperature), f.temperature, row.names=FALSE)


}
