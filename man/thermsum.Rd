\name{thermsum}
\alias{thermsum}
\title{
Return summary of thermal image data.
}
\description{
Provides typical summary data (min, max, mean, sd, median) of a vector of raw binary thermal encoded data.  If templookup is not provided, the summary info is conducted on the data provided.  If a templookup vector is provided (see Examples in raw2temp function), the dat values are converted to temperature before summary information is extracted.
}
\usage{
thermsum(dat, templookup = NULL)
}
\arguments{
  \item{dat}{
An integer vector of raw binary thermal information (usually) extracted from a thermal video or image using the getFrames or readflirJPG functions to be converted to temperature and summarised.  Instead, this can be a vector of temperature values (numeric); if so, then templookup should be set to NULL or ignored.
}
  \item{templookup}{
A vector of temperatures converted using the raw2temp function, corresponding to the conversion from raw binary thermal information to calibrated temperature estimates.  Typically will be vector of numbers 2^16 long, for a 16-bit camera.  Default is NULL, which assumes that dat has already been converted to temperature.
}

}
\details{
A simple summary function for thermal imaging data to allow for extraction of basic statistical data from a thermal image dataset.  If dat is supplied as an integer vector of raw binary values, then templookup should be supplied to use as an indexing function. 

Using raw2temp(1:65535) will produce a vector of temperatures that correspond to the indexed integers 1:65535.  This method of calculation can be faster on large video files.  The default settings for raw2temp() will not be appropriate, and all camera settings should be used according to calibration constants.

If dat is supplied as a vector of temperatures, then templookup must be left blank or NULL as the default.  Summary information will be calculated on the dat variable assuming it is properly calibrated temperature values.

As written, this is a vectorised function, so will only calculate summary on the vector provided.  To perform thermal summaries on multiple frames from the raw binary video data, use a for-loop (usually slow) or the apply function to process (faster processing) or parallel apply functions (best).  
}
\value{
Returns a named vector: Mintemp, Maxtemp, Meantemp, SDtemp, and Mediantemp 
}

\author{
Glenn J Tattersall
}

\section{Warning}{This function simply calculates summary data, and does not detect objects in the image frame.  Use only as rapid way to extract thermal information.  This is not a replacement for doing analysis by hand, and may only be useful for objects that are stationary and remain within the image frame over time.}

\seealso{
\code{\link{raw2temp}}, 
\code{\link{thermsumcent}}
}
\examples{
# set w to 640 and h to 480
w<-640
h<-480
f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)
suppressWarnings(templookup<-raw2temp(1:65535))
alldata<-unlist(lapply(x$f.start, getFrames, vidfile=f, w=w, h=h))
alldata<-matrix(alldata, nrow=w*h, byrow=TRUE)

# Summary on one image or frame of data
thermsum(alldata[,1], templookup)

# Summary on multi-frame seq file
tsum<-data.frame(t(apply(alldata, 2, thermsum, templookup)))
tsum

# Randomly generated data
alldata<-floor(runif(w*h*10, 17000, 25000))
alldata<-matrix(alldata, nrow=w*h)

# depending on the size of alldata, directly calculating temperature can slow down processing
# For a 10 frame file:
system.time(alltemperature<-raw2temp(alldata))

# But summary calculations using raw binary with lookup are slightly slower than
# using numeric temperatures:

# Perform calculations on the raw binary but supply the templookup vector
system.time(tsum<-data.frame(t(apply(alldata, 2, thermsum, templookup))))

# Perform calculations on the converted temperature values
system.time(tsum<-data.frame(t(apply(alltemperature, 2, thermsum))))
tsum



}
