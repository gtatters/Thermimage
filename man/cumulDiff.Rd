\name{cumulDiff}
\alias{cumulDiff}
\title{
Cumulative difference sum function for use with frame by frame difference dataframe
}
\description{
Based on the absolute difference sum method (Lighton and Turner, 2004), this function takes a difference frame dataframe, where each column corresponds to a video frame (i+1) that has been subtracted from the previous (ith) frame. Each row corresponds to a pixel difference value.  
}
\usage{
cumulDiff(fdiff, extract.times, samples = 2)
}

\arguments{
  \item{fdiff}{
Dataframe containing the frame by frame differences obtained from the diffFrame function.  Rows corresponds to the pixel dimensions (w x h) of each frame and Columns (C-1) correpond to the number of columns, which is one fewer columns compared to the original video dataframe.
}
  \item{extract.times}{
A vector of times (POSIXct format) that corresponds to the actual frames from the original video file.  This should be length of C.
}
  \item{samples}{
The number of samples over which to calculate the slope of the cumulative difference sums.  Must be >= 2, as it will calculate the slope over at least two frames.
}
}
\details{
Each row in fdiff corresponds to a specific pixel position in a thermal video frame.  Data frames are preferred over array functions for speed and simplicity.  Row numbers range from 1 through to the image dimensions (i.e. w*h = 640 * 480=307200). Image dimensions are not required, provided the row number corresponds to the same relative position.

The premise behind this is that the thermal video is either time lapse or higher speed video. If a specific pixel shows no change (0) from frame to frame, then there is no movement or temperature change.  For videos of living specimens, movement artefacts will manifest as change over time at specific pixels.  If there is sufficient movement, across the image space, the accumulation of small differences will provide a measure of relative activity from frame to frame.

cumulDiff takes the average, standard deviation and rootmean square of all pixels within one frame to arrive at an aggregate value for each difference frame (absolute value).  Subsequently, it sums these successive data points (avg,sd,rms) across all frames, arriving at an absolute difference summation.  This results in an incrementing value, of which the slope will be a semi-quantitative assessment of relative change.  It also provides a clean break point when activity ceases (Lighton, 2008).  

The extract.times value (POSIX) is required to provide a time index as well as to calculate the frame rate.  

}
\value{
Returns a list variable, containing raw, cumulative difference calculations and the slope calculations on a minimum of 2, preferrably every 3rd frame.

\item{rawdiff}{rawdiff is a table of the cumulative average, sd, and rms values}
\item{slopediff }{slopediff is the summarised rates of change over time in the rawdiff values}

}
\references{
1. Lighton, J.R.B., and Turner, R.J. (2004). Thermolimit respirometry: an objective assessment of critical thermal maxima in two sympatric desert harvester ants, Pogonomyrmex rugosus and P. californicus. J Exp Biol 207: 1903-1913.

2. Lighton, J. R. B. (2008). Measuring metabolic rates : a manual for scientists. Oxford ; New York, Oxford University Press.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{diffFrame}}
}
\examples{

# Create a vector of arbitrary frame times - these would be extracted normally using the 
# locateFrames and getTimes functions

start<-as.POSIXct("2017-03-31 12:00:00")
fdiff<-data.frame(matrix(runif(307200*20, 20, 40), nrow=307200))

# add noise to pixels
for(i in 1:20){
  randpixels<-floor(runif(10000, 1,307200))
  fdiff[randpixels,i]<-fdiff[randpixels,i]*runif(1, 10, 10000)
}

extract.times<-seq(start, start+20,1)
cumulDiff(fdiff, extract.times, 2)


}

