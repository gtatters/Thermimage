\name{meanEveryN}
\alias{meanEveryN}

\title{
Calculate the mean every nth data point.
}
\description{
meanEveryN calculates the mean of a vectorised data set (x) at N intervals.  Means are
calculated by centring around every nth data point in the vector.  Upon running the function,
it attempts to subdivide the vector into n discrete intervals.  If the vector length is not
fully divisible by n, then the remainder elements are forced to NA values and the final mean
calculated.  

The function returns a labelled matrix, with the average index as the first column and the
mean over that range of data.
}
\usage{
meanEveryN(x, n = 2, lag = round(n/2),showsamples=FALSE)
}
\arguments{
  \item{x}{
numeric vector containing the data over which mean is required.  Typically this is a vector of data 
that has been sampled at even time intervals (represented by n). 
}
  \item{n}{
the sample interval over which the mean will be calculated.  Default is 2 (as in every 2nd data
point).  At minimum this must be >1.  
}
  \item{lag}{
default value is half the sample interval, n, which will ensure the calculation is centred over the new sample interval.  Not tested for any other situation.  Leave blank to have function operate as intended.
}
  \item{showsamples}{
default value is false.  Determines whether to output a matrix where the first column contains the mean sample #.  If true, the mean sample number is included with the mean calculations of the variable of interest, x.  If false, then only a vector containing the mean values of x will be provided.
}
}
\details{
The general purpose of this function is to assist with time based averaging a data stream typically sampled at evenly recorded time intervals common to computerised data acquisition systems.  Akin to a moving average function, except that it also resamples the data.
}
\value{
A matrix object returned
}
\author{
Glenn J. Tattersall
}
\seealso{
\code{\link{slopeEveryN}}}
\examples{

## Define a vector of 50 random numbers from 1 to 100
#s<-ceiling(runif(50, 0, 100))
#x<-seq(1,50,1)
## Calculate the mean value every 4th point
#s10<-meanEveryN(s,4)

#plot(x,s,type="l",col="red")
#lines(s10,col="black")
}
