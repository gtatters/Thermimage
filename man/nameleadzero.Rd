\name{nameleadzero}
\alias{nameleadzero}
\title{
Add leading zeros to character for easy sequential naming of filenames.
}
\description{
Returns a character with leading zeros according to the total number of filenames to be created.  Useful when exporting multiple images arising from imported video data stored as a matrix or dataframe.  By providing a base root name, the function will then add leading zeroes ahead of the number suffix (counter variable), according to the no.digits requested (i.e. Img0001.png, Img0002.png,...Img9999.png).  Best used inside a loop exporting images.
}
\usage{
nameleadzero(filenameroot = "Img", filetype = ".png", no.digits = 5, counter = 1)
}
\arguments{
  \item{filenameroot}{
Prefix or root filename, supplied as a character vector.
}
  \item{filetype}{
The type of file to be saved, as a character.  i.e. ".png", or ".csv".  
}
  \item{no.digits}{
The total number of digits required for the suffix portion of the complete filename.  Use 2 if numbers range from 1 to 99.
}
  \item{counter}{
The specific counter to add to the suffix.  Typically counter is a number. 
}
}
\details{
Although this returns a single character value with leading zeros, it could be used in a loop to create a new, incremented file name (i.e. Img0001.png, Img0002.png, Img0003.png,... Img9999.png), or wrapped in an apply function: 
}
\value{
Returns a character value.
}

\author{
Glenn J Tattersall
}

\examples{

# Using for-loop 
prefix<-"Img_"
filetype<-".png"
no.digits<-2
for(i in 1:10){
  f.txt<-nameleadzero(prefix, filetype, no.digits, counter=i)
  print(f.txt)
}

# Using an apply function
x<-unlist(lapply(1:10, nameleadzero, filenameroot="Img_", filetype=".png", no.digits=2))
x

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
