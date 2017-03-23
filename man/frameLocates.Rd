\name{frameLocates}
\alias{frameLocates}
\title{
Find the frame read start positions in a thermal video file.
}
\description{
Using readBin function, find everywhere in file vector where thermal resolution info is stored: i.e. 640x480, 320x240.  These positions denote where the image frame data is found in the larger video file and will facilitate extraction. 
}
\usage{
frameLocates(vidfile = "", w = 640, h = 480, res2fram = 15)
}

\arguments{
  \item{vidfile}{
Filename or filepath (as character) of the thermal video.  Should end in .seq or .fcf.  Not tested comprehensively so it may only work for certain camera models and software packages.  
}
  \item{w}{
Width resolution (pixels) of thermal camera.  Can be found by using the flirsettings function.
}
  \item{h}{
Height resolution (pixels) of thermal camera. 
}
  \item{res2fram}{
# res2fram = frame data stream commences 15 bytes after where the resolution info (w,h) is found
}
}
\details{
FLIR cameras have built-in radiometric video saving functions.  FLIR software also has similar video, or time lapse, functionality.  These files are typically stored as .seq or .fcf and encode information on the thermal imaging camera model, calibration, date/time, etc.  These meta-tages can be extracted using system installed software (Exiftool).  

This function makes use of the readBin function in the R base package, by loading a small portion of the file as two-byte integers in little endian order.  It then searches through this data vector for the two-number sequence (w,h) which corresponds to meta-tags referring to the frame width and height which are typically stored 30 bytes ahead of the image pixel data.  The actual start of the header information is empirically determined by the pattern of (w,h) locations within the file.  

Frame refers to the still frame that is to be extracted from the thermal video file.

The function returns a list, containing the header start (h.start) position of each frame and the frame start (f.start) where pixel data is stored in raw, binary format (at present, in 16-Bit integers).  

h.start and f.start can be passed to other functions to extract the precise times of each frame (getTimes) and to extract the actual frame by frame data (getFrames).

The length of h.start and f.start should be the same.  If these are blank, then the detection process has not worked and the filetype might not be supported by this function.

}
\value{
Returns a list, containing two vectors, h.start and f.start.  These should be the same length.

\item{h.start}{A vector containing the read position start points in the file to extract header information from each frame.  Typically passed to the getTimes function.}
\item{f.start}{A vector containing the read position start points in the file to extract raw, binary pixel data from each frame.  Typically passed to the getFrames function.}

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
\code{\link{getFrames}},
\code{\link{getTimes}},
\code{\link{readBin}}
}
\examples{

x<-frameLocates(vidfile = system.file("extdata", "SampleSEQ.seq", package = "Thermimage"))
x$h.start
x$f.start

}
