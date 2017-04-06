\name{diffFrame}
\alias{diffFrame}
\title{
A frame difference function for subtracting adjacent frames from an imported thermal image sequence.
}
\description{
Works similarly to the simple diff() function, but on a data.frame.  Subtracts column i from column i+1, assuming each column represents the pixel information for one frame of an imported thermal image video.  Each row in the column corresponds to a pixel.  Returns a data.frame of one column shorter dimension than the original data.frame.
}
\usage{
diffFrame(dat, absolute = TRUE)
}

\arguments{
  \item{dat}{
A data.frame of R x C dimensions, where R represents the specific pixel, ranging from 1 to w x h rows, and C represents the frame number.  
}
  \item{absolute}{
If set to TRUE (default) the absolute difference between the value for each pixel is provided.  If set to FALSE, it will return the true difference (negative/positive values).  
}
}
\details{
Providing a data frame of R x C dimensions, returns a data frame of R x (C-1) dimensions, where each column represents the difference between adjacent columns.  Absolute or relative values are provided. 

Each row in dat corresponds to a specific pixel position in a thermal video frame.  Data frames are preferred over array functions for speed and simplicity.  Row numbers range from 1 through to the image dimensions (i.e. w*h = 640 * 480=307200).  

The premise behind this is that the thermal video is either time lapse or higher speed video. If a specific pixel shows no change (0) from frame to frame, then there is no movement or temperature change.  For videos of living specimens, movement artefacts will manifest as change over time at specific pixels.  If there is sufficient movement, across the image space, the accumulation of small differences will provide a measure of relative activity from frame to frame.

In combination of a cumulative summation function (cumulDiff), the diffFrame function can assess relative change in movement or activity.  This makes use of a concept called the absolute difference sum method, sometimes used to simplify noisy data.  See cumulDiff for further info.
}
\value{
Returns a data frame of R x (C-1) dimensions, where each column represents the difference between adjacent columns.  
}
\references{
1. Lighton, J.R.B., and Turner, R.J. (2004). Thermolimit respirometry: an objective assessment of critical thermal maxima in two sympatric desert harvester ants, Pogonomyrmex rugosus and P. californicus. J Exp Biol 207: 1903-1913.

2. Lighton, J. R. B. (2008). Measuring metabolic rates : a manual for scientists. Oxford ; New York, Oxford University Press.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{cumulDiff}}
}
\examples{

# set w to 640 and h to 480
w<-640
h<-480
f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)
suppressWarnings(templookup<-raw2temp(1:65535))
alldata<-unlist(lapply(x$f.start, getFrames, vidfile=f, w=w, h=h))
alldata<-matrix(alldata, nrow=w*h, byrow=FALSE)
alltemperature<-templookup[alldata]
alltemperature<-unname(matrix(alltemperature, nrow=w*h, byrow=FALSE))

dalltemperature<-as.matrix(diffFrame(alltemperature, absolute=TRUE), nrow=w)

# Plot 
plotTherm(dalltemperature[,1], templookup=NULL, w=w, h=h,  minrangeset=min(dalltemperature),
          maxrangeset=max(dalltemperature), trans="mirror.matrix")



}

