\name{convertflirVID}
\alias{convertflirVID}
\title{
Convert FLIR CSQ or SEQ into PNG or AVI, using shell commands.
}
\description{
Invoking shell commands to act on a FLIR video (SEQ or CSQ file type) and calls the exiftool -RawThermalImage option to extract the raw, binary thermal image frames in 16 bit format and pass these to ffmpeg to convert the output as a series of png files or as an avi video file.
}
\usage{
convertflirVID(imagefile, exiftoolpath="installed", perlpath="installed",
fr=30, res.in="1024x768", res.out="1024x768", outputcompresstype="jpegls", 
outputfilenameroot=NULL, outputfiletype="avi", outputfolder="output", ...)
}

\arguments{
\item{imagefile}{
Name of the FLIR SEQ or CSQ file to read from, as captured by the thermal camera.  A character string.
}
\item{exiftoolpath}{
A character string that determines whether Exiftool has been "installed" or not.  If Exiftool has been installed in a specific location, use to direct to the folder location.
}
\item{perlpath}{
A character string that determines whether Perl has been "installed" or not.  If Perl has been installed in a specific location, use to direct to the folder location.
}
\item{fr}{
Frame rate of input video data, frames per sec.  Default = 30.
}
\item{res.in}{
Input file image resolution in text format, "wxh".  Default = "640x480"
}
  \item{res.out}{
Desired output file image resolution in text format, "wxh". Decrease to make smaller file, but maintain same aspect ratio.  Default = "640x480".
}
  \item{outputcompresstype}{
Desired output file image compression format.  Possible values are "tiff", "png" or "jpegls" (or any modifier from ffmpeg -vcodec).  Default = "png".
}
  \item{outputfilenameroot}{
The base root of the output file(s) to be exported, without the indexing.  If NULL, then the input filenameroot will be used and a numeric index attached.  Default is NULL.
}
  \item{outputfiletype}{
Desired output file type, "avi" or "png".  If "png", multiple files will be exported.  If "avi", a single video file will be exported.  Default = "avi"
}
\item{outputfolder}{
Desired output subfolder name, placed inside the folder where the input files are stored.  Default = "output".
}
\item{\dots}{
Other values to pass to command line functions.
}
}
\details{
Calls exiftool, imagemagick, and ffmpeg in shell to convert a thermal image video file (SEQ or CSQ) into a 16 bit grayscale avi or series of images corresponding to each frame of the input video.

}
\value{
No output generated in R.  Shell call to exiftool, imagemagick, and ffmpeg to convert files.
}
\references{
1. https://www.sno.phy.queensu.ca/~phil/exiftool/

2. https://www.imagemagick.org/script/index.php

3. https://www.eevblog.com/forum/thermal-imaging/csq-file-format/
}
\author{
Glenn J. Tattersall
}
\note{
This function requires that exiftool and imagemagick are installed.  Consult with the references for how to install.
}

\seealso{
\code{\link{convertflirJPG}}, 
\code{\link{ffmpegcall}}, 
\code{\link{readflirJPG}}, 

}
\examples{
# Based on the following command line unix code, this function will convert a 
# flir jpg into a 16 bit greyscale video or sequence of images for import into imageJ

# Equivalent command line code:
# ffmpeg -f image2 -vcodec tiff -r 30 -s 640x480 -i 'output/frame\%05d.tiff' -pix_fmt gray16be 
# -vcodec png -s 640x480 file.avi

# Examples 
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

# See https://github.com/gtatters/FLIRJPGConvert/blob/master/FLIRJPG_Convert.R 

# See https://github.com/gtatters/Thermimage/blob/master/README.md


}

