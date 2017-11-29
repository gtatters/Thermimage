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
Only tested on a select number of FLIR JPGs.  Usage depends on functionality provided by Exiftool.  At present this function first makes use of readBin to read in thermal image jpgs and searches for the magic start byte sequence ("54", "49", "46", "46","49", "49") for TIFF type images or ("89", "50", "4e", "47", "0d", "0a", "1a", "0a") for PNG type images, and then uses the readTIFF or readPNG functions to load into R.

Exiftool should install on most operating systems.  Consult with http://www.sno.phy.queensu.ca/~phil/exiftool/ for information on installing Exiftool.  If trouble installing, download Exiftool perl scripts and set exiftoolpath to the custom folder location to access the perl scripts that are attached with this package.  The version of Exiftool installed with Thermimage package has not been tested on all OS.

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
\note{
Loading image files and manipulating them in R is slow.  Consider using command line tools like exiftool, imagemagick, and ffmpeg to convert the files into a format to analyse in ImageJ, where more powerful plug-ins can be accessed. 

Alternatively, convertflirjpg and convertflirvid functions are wrappers that will call command line tools and convert flir files in the shell environment.
}
\seealso{
\code{\link{temp2raw}}
\code{\link{raw2temp}}
\code{\link{convertflirJPG}}
\code{\link{convertflirVID}}
}
\examples{
# Examples 
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

}
