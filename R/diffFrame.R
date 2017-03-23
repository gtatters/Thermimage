#' @export
#' 
diffFrame<-function(dat, absolute=TRUE)
  {
  # function takes a dataframe that corresponds to the video data and subtracts frame i+1 from frame i
  # frames are stored successively as columns in the dataframe, such that each row corresponds to the 
  # the same pixel across all frames
  # returns a difference dataframe, one column less than the original data
  shift<-1
  startcol<-shift+1
  lastcol<-ncol(dat)
  if(absolute==TRUE){
    fdiff<-abs(dat[, startcol:lastcol] - dat[, 1:(lastcol-1)])
  }
  else if(!absolute==TRUE){
    fdiff<-(dat[, startcol:lastcol] - dat[, 1:(lastcol-1)])
  }
  return(fdiff)
}
