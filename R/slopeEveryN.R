#' @export
#' 
slopeEveryN <-
function(x, n=2, lag=round(n/2)) {
  # only to be applied to a vector (x) of data 
  # will first convert vector to a matrix of n rows by length/n columns
  # thus allowing for apply to be invoked across a specific column of values
  # if each column is n samples in size
  # added lag to allow the slope calculation to be centred around 
  # the sample period appropriately
  if(n==1) y<-1; z<-1
  if (n>1)
  {
    t<-seq(0,length(x)-1,1) # create a 'false time index' going from 0 to length of vector
    lagx<-x[lag:length(x)]    # re-sample vector x, going from sample (N)/2:  will alow to centre calculations for slope
    len<-length(lagx)
    rem<-len/n-trunc(len/n)   # check if vector is evenly divisible by # samples
    newlen<-len-rem*n           
    lagt<-t[lag:length(t)]    # create corresponding time vector according to the lag
    final.x<-rep(NA,newlen)       # create new vector (xxx) that is an evenly divisible length filled with NA
    final.t<-rep(NA,newlen)       # create new vector (ttt) that is an evenly divisible length filled with NA
    #lagx<-replace(xx,1:newlen,x) # fill xx with the values from x, leaving final NA values if exist
    final.x<-lagx[1:newlen]
    final.t<-lagt[1:newlen]
    resam<-matrix(matrix(final.x), nrow=n) # convert vector to matrix to allow the BY column calculation
    retim<-matrix(matrix(final.t), nrow=n) # convert 
    y<-apply(retim,2,mean)
    z<-apply(resam,2,slopebypoint)
  }
  zz<-cbind(y,z)
  colnames(zz)<-c("Sample","Slope")
  zz<-zz
}
