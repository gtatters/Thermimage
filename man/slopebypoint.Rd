\name{slopebypoint}
\alias{slopebypoint}
\title{
Returns the slope from linear regression with x values as equally spaced 1:length
}
\description{
Returns the slope from linear regression with x values as equally spaced 1:length
}
\usage{
slopebypoint(data)
}
\arguments{
  \item{data}{
Returns the slope from linear regression with x values as equally spaced 1:length
}
}
\details{
Returns the slope (i.e. localised tangent) from linear regression with x values as equally spaced 1:length.  The usefulness of this function is to reduce a time series type of data collected at equal time intervals.  N=number of data points over which to calculate the slope.
}
\value{
An object of type numeric.  
}
\author{
Glenn J. Tattersall
}
\seealso{
\code{\link{lm}}
}
\examples{




}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
