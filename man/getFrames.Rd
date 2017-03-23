\name{getFrames}
\alias{getFrames}
\title{
Extract raw binary thermal from thermal image file.
}
\description{
Extracts raw binary thermal image data in integer format as a vector
}
\usage{
getFrames(vidfile, framestarts, w = 640, h = 480, l = w * h, byte.length = 2)
}
\arguments{
  \item{vidfile}{
Filename or filepath (as character) of the thermal video.  Should end in .seq or .fcf.  Not tested comprehensively so it may only work for certain camera models and software packages.
}
  \item{framestarts}{
A vector of integers corresponding to the actual pixel read byte start positions in the thermal video file.  Acquired using the getFrames function.
}
  \item{w}{
Width of thermal image.
}
  \item{h}{
Height of thermal image
}
  \item{l}{
The total size (length) of pixel data corresponding to one image = width * height.  User does not need to set this.
}
  \item{byte.length}{
Set to 2 by default.  Each pixel information is encoded in two bytes (i.e. 16 bit), leading to an integer value ranging from 1 to 2^16. Pixel data are read in order in the file and converted to integer using the readBin function. User does not need to set this.
}
}
\details{
This function will load into memory the raw binary pixel data from the entire thermal video file.  Data are stored linearly as read in using the readBin function, but the number of frames read in can be determined by dividing the length of the vector by (w*h).  Depending on the size of the video, this can become quite large.  

Frame data is stored as a vector to speed calculations.  Thermal video files may exceed memory capacity of some systems, so processing as arrays or dataframes is generally avoided.

As written, this is a vectorised function, so will only load in one frame is used normally.  To load multiple frames from the video file, use a for-loop (usually slow) or the apply function to import (faster processing) or parallel apply functions (best).  
}
\value{
Returns a vector of integers, each item corresponding to raw pixel value.  With information on thermal image width and height, the specific image can be reconstructed.  To be used in conjunction with raw2temp function which will convert this raw binary value into an estimated temperature.
}
\references{
1. http://www.sno.phy.queensu.ca/~phil/exiftool/
2. http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/FLIR.html
}
\author{
Glenn J Tattersall
}
\note{
Requires Exiftool be installed in order to automatically determine thermal image width and height.  If you know the width and height in pixels, then the frame start locations can be determined.

For information on installing Exiftool, see http://www.sno.phy.queensu.ca/~phil/exiftool/
}

\seealso{
\code{\link{frameLocates}},
\code{\link{getTimes}},
\code{\link{readBin}},
\code{\link{raw2temp}}

}
\examples{
# set w to 640 and h to 480

w<-640
h<-480
f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)

# Slow approach:
system.time({
  alldata<-matrix(nrow=w*h, ncol=length(x$f.start))
  for(i in 1:length(x$f.start)) alldata[,i]<-getFrames(f, x$f.start[i], w, h)
})
dim(alldata)

# Faster approach
alldata<-NULL
system.time(alldata<-unlist(lapply(x$f.start, getFrames, vidfile=f, w=w, h=h)))
length(alldata)/(w*h)

# Parallel approach (will not be faster on small files)
library(parallel)
alldata<-NULL
# set mc.cores to higher number to use parallel processing
system.time(alldata<-unlist(mclapply(x$f.start, getFrames, vidfile=f, mc.cores=1)))
length(alldata)/(w*h) # number of frames in video

}

