\name{writeFlirBin}
\alias{writeFlirBin}
\title{
Saves thermal image data to a binary file
}
\description{
Saves thermal image data to a binary file.  This function serves to allow thermal images that have been imported into R to be exported to a raw, 32-bit real format that can then be imported and analysed in ImageJ.  
}
\usage{
writeFlirBin(bindata, templookup, w, h, Interval, rootname)
}
\arguments{
  \item{bindata}{
Vector of raw binary data imported from a thermal image file, using the getFrames function.  Each value corresponds to the raw binary sensor value for each pixel.  Should be supplied as a vector, not a dataframe or matrix.
}
  \item{templookup}{
A vector of values from 1:65535 (2^16) that serves as a rapid means to convert the above bindata into calibrated temperature data for each pixel.  This makes use of the raw2temp function.  This value must be supplied and properly calibrated, otherwise the conversion will not be correct.  Default is set to NULL.  If calibrated temperature data is supplised as bindata, then templookup should be set to NULL.
}
 
  \item{w}{
Width resolution (pixels) of thermal camera.  Can be found by using the flirsettings function.
}
  \item{h}{
Height resolution (pixels) of thermal camera.  Can be found by using the flirsettings function.
}
  \item{Interval}{
Time inverval (in seconds = 1 / Frame rate) of the thermal video file.  Used for encoding in filename. 
}
  \item{rootname}{
Root name (character) for saving the binary file
}
}
\details{
This function exports raw binary information from the getFrames function in a 32-bit real file format (4 bytes).  This file format can be relatively easily imported into ImageJ using the Import-Raw option, choose 32-bit Real, set your image width and height and # of frames. Little endian and hyperstack options must be enabled during import.

The file naming takes the rootname and appends image width, height, number of frames, and image interval, appending .raw to the end to make ImageJ import easier. 

If rootname = 'Thermvid', w=640, h=480, number of frames=100, and image interval is 0.0333 seconds, the file name will be saved as:

'Thermvid_W640_H480_F100_I0.0333.raw'

}
\value{
Returns nothing, but saves a new file to the current working directory. 
}

\author{
Glenn J Tattersall
}

\section{Warning}{This function has not been fully tested with all possible video/camera combinations.  Users are advised to compare the exported values in ImageJ on sample images to standard FLIR software values before proceeding with analysis.
}

\seealso{
\code{\link{raw2temp}},
\code{\link{getFrames}},
\code{\link{readBin}},
\code{\link{writeBin}}
}
\examples{

bindata<-floor(runif(307200, 17000, 25000))
templookup<-raw2temp(bindata)
w<-640
h<-480
Interval<-0.03
f.root<-"Thermalvid"

# Usage:
# writeFlirBin(bindata, templookup=templookup,  w=w, h=h, Interval=Interval, rootname=f.root)

}

