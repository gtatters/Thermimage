\name{locate.fid}
\alias{locate.fid}
\title{
Returns the index locations that match vector fid within data vector.
}
\description{
Returns the index locations that match vector fid within data vector.
}
\usage{
locate.fid(fid,data)
}

\arguments{
\item{fid}{
A lookup vector, typically numeric, which can be 1 element long or greater.  This sequence of values will be searched within the data vector.
}
\item{data}{
Data vector of interest, within which fid will be searched.
}
}
\details{
Returns the positions within the data vector where fid is found.  If length(fid)>1, the elements of fid must be adjacent and in that specific order.
}
\value{
An object of type integer.  
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

## Define a vector of 100000 random numbers from 1 to 100
s<-ceiling(runif(100000, 0, 100))
## Define what fid sequence to look for: i.e. what adjacent elements to look for in this order
fid<-c(22,48)
# look for all instances where 22 and 48 occur together, using locate.fid
where.locate<-locate.fid(fid,s) 
where.locate
# verify that locate.fid worked by subsetting s, using where.locate as index
s[where.locate]

}
