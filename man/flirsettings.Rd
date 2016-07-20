\name{flirsettings}
\alias{flirsettings}
\title{
Extracts meta tag information from a FLIR JPG image
}
\description{
Extracts meta tag information from a FLIR JPG image using system installed Exiftool application.  Use this to obtain thermal image calibration values, date/time stamps, object distance, and 
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
FLIR JPG file should be the original captured file, not a modified JPG.  

Exiftool should install on most operating systems.  Consult with http://www.sno.phy.queensu.ca/~phil/exiftool/ for information on installing Exiftool.  If trouble installing, download Exiftool perl scripts and set exiftoolpath to the custom folder locationto access the perl scripts that are attached with this package.  The version of Exiftool installed with Thermimage package has not been tested on all OS.

For camvals, provide a character string as described in Exiftool documentation.   Set camvals="-*Emissivity", to simply return the Emissivity value stored in FLIR jpg.
Set camvals="-*Planck*" for camera calibration constants.

}
\value{
Returns a list of camera meta tags for use in thermal imaging calculations.  

Info is the basic list of camera settings.

Dates will be the date values associated with the image creation, modification etc.
}
\references{
http://www.sno.phy.queensu.ca/~phil/exiftool/
}
\author{
Glenn J Tattersall
}

\examples{

# Example Use
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R



}

