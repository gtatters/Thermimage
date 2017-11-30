\name{convertflirJPG}
\alias{convertflirJPG}
\title{
Convert FLIR jpg into 16 bit grayscale file using shell commands.
}
\description{
Invoking shell commands to act on a FLIR jpg and calls the exiftool -RawThermalImage option to extract the raw, binary thermal image data in 16 bit format and passes this to imagemagick's convert function to swap the byte order (if necessary) and output as a png file.
}
\usage{
convertflirJPG(imagefile, exiftoolpath="installed", res.in="640x480", 
endian="lsb", outputfolder="output", ...)
}
\arguments{
\item{imagefile}{
Name of the FLIR JPG file to read from, as captured by the thermal camera.  A character string.
}
\item{exiftoolpath}{
A character string that determines whether Exiftool has been "installed" or not.  If Exiftool has been installed in a specific location, use to direct to the folder location.
}
\item{res.in}{
Input file image resolution in text format, "wxh".  Default = "640x480"
}
\item{endian}{
Byte order ("lsb" = least significant byte or "msb" = most significant byte) used in converting raw thermal image in call to imagemagick's convert function.  Byte order can be set according to the inherent raw thermal data type.  TIFF type raw thermal image data are saved as lsb, PNG type raw thermal image data are saved as msb. 
}
\item{outputfolder}{
Desired output subfolder name, placed inside the folder where the input files are stored.  Default = "output".
}
\item{\dots}{
Other values to pass to command line functions.
}
}
\details{
Calls exiftool and imagemagick (convert) in shell to convert a FLIR jpg, using the command line exiftool, and passing that raw thermal binary datat to convert to create a png file.  The subsequent converted file is a 16 bit grayscale png, with each pixel representing the uncalibrated raw sensor radiance data from the thermal imaging camera.  This raw png file can be loaded into ImageJ for further analysis.

For example, a typical shell call might look like:

exiftool FLIRjpgfilename.jpg -b -RawThermalImage | convert - gray:- | convert -depth 16 -endian lsb -size 640x480 gray:- Outputfilename.png


}
\value{
No output generated in R.  Shell call to exiftool and imagemagick to convert flir jpg files to png files.  exiftool and imagemagick must be installed on the system.  Files generated require further processing to estimate temperature.  
}
\references{
1. https://www.sno.phy.queensu.ca/~phil/exiftool/

2. https://www.imagemagick.org/script/index.php
}
\author{
Glenn J. Tattersall
}
\note{
This function has not been fully tested with all flir jpg types.  Multiburst images and older camera file types may not work.

This function requires that exiftool and imagemagick are installed.  Consult with the references for how to install
}

\seealso{
\code{\link{convertflirVID}}, 
\code{\link{ffmpegcall}}, 
\code{\link{readflirJPG}}, 

}
\examples{
# Based on the following command line unix code, 
# this function will convert a flir jpg into a 16 bit 
# greyscale png to import into imageJ

# Equivalent command line code:
# exiftool FLIRjpgfilename.jpg -b -RawThermalImage | convert - gray:- | 
# convert -depth 16 -endian lsb 
# -size 640x480 gray:- Outputfilename.png

# Examples
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

# See https://github.com/gtatters/FLIRJPGConvert/blob/master/FLIRJPG_Convert.R 

# See https://github.com/gtatters/Thermimage/blob/master/README.md
}
