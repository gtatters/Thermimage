\name{flirsettings}
\alias{flirsettings}
\title{
Extracts meta tag information from a FLIR JPG image
}
\description{
Extracts meta tag information from a FLIR JPG image using system installed Exiftool application.  Use this to obtain thermal image calibration values, date/time stamps, object distance, and other parameters saved in FLIR image or video files. 
}
\usage{
flirsettings(imagefile, exiftoolpath = "installed", camvals = NULL)
}
\arguments{
  \item{imagefile}{
Name of the FLIR JPG file to read from, as captured by the thermal camera.  A character string.
}
  \item{exiftoolpath}{
A character string that determines whether Exiftool has been "installed" (http://www.sno.phy.queensu.ca/~phil/exiftool/) or not.  If Exiftool has been installed in a specific location, use to direct to the folder location.
}
\item{camvals}{
A list of arguments to be passed to Exiftool as described in Exiftool documentation.  A character string.  Default value (recommended) is "", which will pass all possible arguments to Exiftool.
}
}
\details{
The imagefile should be the original captured FLIR JPG file, not a modified JPG. This also works with FLIR video files (.seq and .fcf).    

Exiftool should install on most operating systems.  Consult with http://www.sno.phy.queensu.ca/~phil/exiftool/ for information on installing Exiftool.  If trouble installing, download Exiftool perl scripts and set exiftoolpath to the custom folder locationto access the perl scripts that are attached with this package. 

For camvals, provide a character string as described in Exiftool documentation.   Set camvals="-*Emissivity", to simply return the Emissivity value. Set camvals="-*Planck*" for camera calibration constants.

Note: the Emissivity value is simply that which is stored in the file.  It typically is the default value the camera is set to (0.95), but this does not mean that the true Emissivity of the surface is what is stored in the file.  Similar caution is advised regarding the environmental parameters returned from the meta tags.  User knowledge is required.

}
\value{
Returns a list of camera meta tags for use in thermal imaging calculations.  

Info is the basic list of camera settings.

Dates will be the date values associated with the image creation, modification etc.
}
\references{
1. http://www.sno.phy.queensu.ca/~phil/exiftool/
2. http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/FLIR.html
}
\author{
Glenn J Tattersall
}

\note{
Requires Exiftool be installed.  see http://www.sno.phy.queensu.ca/~phil/exiftool/
}

\examples{
\dontrun{
## To access meta-tag information from a flir jpg or flir file:

## Example using the flirsettings functions:

library(Thermimage)
## Sample flir jpg included with Thermimage package:

imagefile<-paste0(system.file("extdata/IR_2412.jpg", package="Thermimage"))

## Extract meta-tags from thermal image file ##
cams<-flirsettings(imagefile, exiftool="installed", camvals="")
cams

## Set variables for calculation of temperature values from raw A/D sensor data
Emissivity<-cams$Info$Emissivity      # Image Saved Emissivity - should be ~0.95 or 0.96
ObjectEmissivity<-0.96                # Object Emissivity - should be ~0.95 or 0.96
dateOriginal<-cams$Dates$DateTimeOriginal
dateModif<-   cams$Dates$FileModificationDateTime
PlanckR1<-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
PlanckB<-     cams$Info$PlanckB                       # Planck B constant for camera  
PlanckF<-     cams$Info$PlanckF                       # Planck F constant for camera
PlanckO<-     cams$Info$PlanckO                       # Planck O constant for camera
PlanckR2<-    cams$Info$PlanckR2                      # Planck R2 constant for camera
ATA1<-        cams$Info$AtmosphericTransAlpha1        # Atmospheric attenuation constant
ATA2<-        cams$Info$AtmosphericTransAlpha2        # Atmospheric attenuation constant
ATB1<-        cams$Info$AtmosphericTransBeta1         # Atmospheric attenuation constant
ATB2<-        cams$Info$AtmosphericTransBeta2         # Atmospheric attenuation constant
ATX<-         cams$Info$AtmosphericTransX             # Atmospheric attenuation constant
OD<-          cams$Info$ObjectDistance                # object distance in metres
FD<-          cams$Info$FocusDistance                 # focus distance in metres
ReflT<-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
AtmosT<-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
IRWinT<-      cams$Info$IRWindowTemperature           # IR Window Temperature
IRWinTran<-   cams$Info$IRWindowTransmission          # IR Window transparency
RH<-          cams$Info$RelativeHumidity              # Relative Humidity
h<-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
w<-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

## See also https://github.com/gtatters/Thermimage/README.md
}


}

