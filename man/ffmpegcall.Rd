\name{ffmpegcall}
\alias{ffmpegcall}
\title{
A simplified wrapper function calling ffmpeg 
}
\description{
A simplified wrapper function calling ffmpeg to convert numbered files extracted from FLIR thermal image videos via exiftool into radiometric png files or radiometric avi files.  Mostly for internal use.
}
\usage{
ffmpegcall(filenameroot, filenamesuffix="\%05d", filenameext="jpegls", 
incompresstype="jpegls", fr=30, res.in="640x480", res.out=res.in, 
outputcompresstype="png", outputfilenameroot=NULL, outputfiletype="avi", 
outputfolder="output",...)
}
\arguments{
  \item{filenameroot}{
The base root of the files to be converted, without the indexing.  If numbered files are: "Frame00001.fff", "Frame00002.fff", etc., then filenameroot = "Frame".
}
  \item{filenamesuffix}{
The suffix defining the indexing numbers associated with filename.  If numbered files are: "Frame00001.fff", "Frame00002.fff", etc., then filenamesuffix = "\%05d"
}
  \item{filenameext}{
File extension for input files.  Typically "jpegls" or "fff"", depending on the video or image filetype (SEQ files are extracted into .fff files; CSQ files are extracted into .jpegls files).  Default = "jpegls".
}
  \item{incompresstype}{
Input file compression type.  Typically "tiff" (non compressed data in SEQ videos files) or "jpegls" (corresponds to jpegls, a lossless jpeg format (see Details and References).
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
Calls ffmpeg in shell to convert a series of image files, named filenameroot\%05d.filenameext, extracted from a thermal image file using the command line tool, exiftool.  The subsequent converted file is a 16 bit grayscale avi or series of images corresponding to each of the input files.

For example, a typical shell call to ffmpeg might look like:

ffmpeg -f image2 -vcodec fff -i frame\%05d.fff -f image2 -vcodec png frame\%05d.png -y

which converts a series of fff files (frameNNNNN.fff) into a series of png files (frameNNNNN.png).

Likewise, the following:

ffmpeg -r 30 -f image2 -vcodec jpegls -s 1024x768 -i frame\%05d.jpegls -vcodec png -s 1024x768 frame.avi -y

converts a series of jpegls files (frameNNNNN.jpegls) into an avi file (frame.avi) with png style compression

Jpeg-ls is a lossless jpg format (JPG-LS) that is used for certain flir image types (e.g., CSQ, Ultramax FLIR jpg).  The easiest means to convert the extracted, compressed data type is with ffmpeg, which contains the codecs for extraction. 

For example, once ffmpeg is installed, try in shell: 

ffmpeg -codecs | grep jpegls

}
\value{
No output generated in R.  Shell call to ffmpeg to convert files.  ffmpeg must be installed on the system.
}
\references{
1. https://www.ffmpeg.org/

2. https://www.eevblog.com/forum/thermal-imaging/csq-file-format/

3. http://www.digitalpreservation.gov/formats/fdd/fdd000151.shtml 
}
\author{
Glenn J. Tattersall
}
\seealso{
\code{\link{convertflirVID}}, 
\code{\link{convertflirJPG}} 
}
\examples{
# Examples 
# See https://github.com/gtatters/FLIRJPGConvert/blob/master/Examples.R

# See https://github.com/gtatters/Thermimage/blob/master/README.md
}

