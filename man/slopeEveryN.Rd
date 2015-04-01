\name{slopeEveryN}
\alias{slopeEveryN}
\title{
Calculate the slope every nth data point.
}
\description{
slopeEveryN calculates the slope of a vectorised data set (x) at N intervals.  Slopes are calculated using the lm() function centred around every nth data point in the vector.  Upon running the function, it attempts to subdivide the vector into n discrete intervals.  If the vector length is not fully divisible by n, then the remainder elements are forced to NA values and the final slope calculated.  

The function returns a labelled matrix, with the average index as the first column and the slope over that range of data.  Units for slope then are technically in un
}
\usage{
slopeEveryN(x, n = 2, lag = round(n/2))
}
\arguments{
  \item{x}{
numeric vector containing the data over which slope is required.  Typically this is a vector of data that has been sampled at even time intervals (represented by n). 
}
  \item{n}{
the sample interval over which the slope will be calculated.  Default is 2 (as in every 2nd data point).  At minimum this must be >1.
}
  \item{lag}{
default value is half the sample interval, n, which will ensure the calculation is centred over the new sample interval.  Not tested for any other situation.  Leave blank to have function operate as intended.
}
}
\details{
he general purpose of this function is to provide a moving average of a data stream typically sampled at evenly recorded time intervals common computerised data acquisition systems.  Akin to a moving average function, except that it also resamples the data.
}
\value{
A matrix object returned
}
\author{
Glenn J. Tattersall
}
\seealso{
\code{\link{slopebypoint}}
}
\examples{



}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
