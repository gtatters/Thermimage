\name{getTimes}
\alias{getTimes}
\title{
Extracts time values from binary imported thermal video file
}
\description{
Extracts time values for each image frame from a thermal camera video file (.seq or with some .fcf).  For time lapse or video capture, computer time is stored for each image frame in 3 chunks, denoting msec, sec, and date information.  
}
\usage{
getTimes(vidfile, headstarts, timestart = 900, byte.length = 1)
}
\arguments{
  \item{vidfile}{
Filename or filepath (as character) of the thermal video.  Should end in .seq or .fcf.  Not tested comprehensively so it may only work for certain camera models, software packages, file type combinations.
}
\item{headstarts}{
A vector of integers corresponding to the header read byte start positions in the thermal video file.  Acquired using the getFrames function.  The header information is where the magicbyte + width + height image information is located (ie. FLIR CameraInfo Tags from the Exiftool library), as well as information on the camera, calibration, time of image capture, etc...are stored.  
}
  \item{timestart}{
Set to 900 by default.  Once the header start location has been determined with the frameLocates function, the frame times were stored in 900 bytes into the header.  The user should not need to set this.
}
  \item{byte.length}{
Set to 1 by default. User does not need to set this.  Deprecated option from an older version of this function.s
}

}
\details{
Somewhat empirically determined, but also information provided on the exiftool website below describes where time stamp information is stored in each file.  This function concatentates the 3 time stamps corresponding to msec, sec, and date into one variable that gives the actual time each image was captured.

As written, this is a vectorised function, so to extract multiple frames of data (i.e. length(headstarts)>1), use a loop or the apply function as shown in the example below. 

Extracted times are used in sumamrising information about the temperature profiles of the thermal videos and can be passed to the cumulDiff function.  

Extracted times can also be used to verify the frame rate of the image capture in the video.  

Has not been fully tested on file types from all cameras or thermal imaging software.


}
\value{
Returns a vector of times as characters corresponding to the frame capture times as extracted from the thermal video file.  Times should resemble those returned using Exiftool.
}
\references{
1. http://www.sno.phy.queensu.ca/~phil/exiftool/

2. http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/FLIR.html

3. http://www.silisoftware.com/tools/date.php

4. http://www.sandersonforensics.com/forum/content.php?131-A-brief-history-of-time-stamps
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{getFrames}},
\code{\link{frameLocates}},
\code{\link{cumulDiff}}
}
\examples{

f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)
getTimes(f, x$h.start)

# only returns the first frame of data, must use lapply to get all frames

# Using lapply
extract.times<-do.call("c", lapply(x$h.start, getTimes, vidfile=f))
extract.times

# Using parallel lapply (uncomment below):
# library(parallel)
## set mc.cores to higher number to use parallel processing:
# extract.times<-do.call("c", mclapply(x$h.start, getTimes, vidfile=f, mc.cores=1))
# extract.times

}
