\name{locate.fid}
\alias{locate.fid}
\title{
Returns the index locations that match vector fid within data vector.
}
\description{
Returns the index locations that match vector fid within data vector.  Used mostly to search for magic byte locations in a raw vector, but can be used to search any vector for locations of fid.
}
\usage{
locate.fid(fid, vect, long = TRUE, zeroindex = TRUE)
}
\arguments{
  \item{fid}{
A lookup vector, typically numeric, which can be 1 element long or greater.  Typical use is
2 elements long. fid<-c(1,2).  This sequence of values will be searched within the data
vector, vect.
}
  \item{vect}{
Data vector of interest, within which fid will be searched.
}
  \item{long}{
Default is TRUE, will use a slower algorithm. When long=true, any length of fid can be used
to search in vector.  Computing time also depends on the length of fid.  Caution advised
when setting long = FALSE.  Null values maye be returned.
}
 \item{zeroindex}{
Whether you wish the returned values to reference 0 as the starting index or 1 as the starting index.  Natural byte reading starts at 0, but in R, indexes start at 1, so set zeroindex=FALSE if you using this simply as a vector lookup tool in R.  Default is TRUE.
}
}
\details{
Returns the positions within the data vector where fid is found.  Do not use this function
if fid is length = 1.  Use which().  If length(fid)>1, the elements of fid must be adjacent
and in that specific order.
}
\value{
An object of type integer, to be used as an index subset.
}
\author{
Glenn J. Tattersall
}
\seealso{
\code{\link{match}}
\code{\link{which}}
}
\examples{

# Similar to the which or match functions in package::base, except that this returns the 
# index placement where variable fid occurs in data

## Define a vector
s<-c(2,3,42,38,88,33,55,99,32,56,22,48,1,2,3,5,6,7,8,9,10,12,20)
## Define what fid sequence to look for: i.e. what adjacent elements to look for in 
## this order
fid<-c(22,48)
## look for all instances where 22 and 48 occur together, using locate.fid
system.time(where.locate<-locate.fid(fid,s,long=FALSE, zeroindex=FALSE))
where.locate
## verify that locate.fid worked by subsetting s, using where.locate as index
s[where.locate]
system.time(where.locate<-locate.fid(fid,s,long=TRUE, zeroindex=FALSE))
s[where.locate]

## longer algorithm check
### Define a vector of 100000 random numbers from 1 to 100
s<-ceiling(runif(100000, 0, 100))
## Define what fid sequence to look for: i.e. what adjacent elements to look for in 
## this order
fid<-c(22,48)
system.time(where.locate<-locate.fid(fid,s,long=TRUE,zeroindex=FALSE))
where.locate
## verify that locate.fid worked by subsetting s, using where.locate as index
s[where.locate]

}
