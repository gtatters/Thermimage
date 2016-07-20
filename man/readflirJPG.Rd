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
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

}
