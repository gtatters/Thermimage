\name{readflirJPG}
\alias{readflirJPG}
\title{
Reads an image from a FLIR JPG file into an integer array.
}
\description{
Reads an image from a FLIR JPG file into an integer matrix, w pixels wide x h pixels high, depending on image size.
}
\usage{
readflirJPG(imagefile, exiftoolpath = "installed")
}
\arguments{
  \item{imagefile}{
Name of the FLIR JPG file to read from, as captured by the thermal camera.  A character string.
}
  \item{exiftoolpath}{
A character string that determines whether Exiftool has been "installed" (http://www.sno.phy.queensu.ca/~phil/exiftool/) or not.  If Exiftool has been installed in a specific location, use to direct to the folder location.
}
}
\details{
Only tested on a select number of FLIR JPGs.  Usage depends on functionality provided by Exiftool.

Exiftool should install on most operating systems.  Consult with http://www.sno.phy.queensu.ca/~phil/exiftool/ for information on installing Exiftool.  If trouble installing, download Exiftool perl scripts and set exiftoolpath to the custom folder locationto access the perl scripts that are attached with this package.  The version of Exiftool installed with Thermimage package has not been tested on all OS.

v 2.2.3: updated to fix a problem calling shell commands requiring folder write access 
on a windows OS (thanks to John Al-Alawneh)

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
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

}
