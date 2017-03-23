#' @export
#' @importFrom stats sd median
#' @importFrom graphics legend matplot
#'
cumulDiff<-function(fdiff, extract.times, samples=2)
  {
  # Converts a difference frame dataframe to summary data
  # The avg and sdev values are simply frame by frame assessments of change. If the frame rate is fast,
  # then changes between frames will be small. To turn this into more meaningful data involves calculating a 
  # cumulative sum function of each of these vectors. 
  # This is referred to as a cumulative summation function, where the 1st value
  # is unchanged, but each successive element in the vector is the sum of the previous 
  # and itself. Total length of this vector is unchanged, since the first element is simply itself.
  # The second element in the cumsum function is the sum of the second + first element of the input.
  # The third element in the cumsum function is the sum of the third + second element of the input.
  # and so on... 
  
  if(samples*2>ncol(fdiff)) {
    print("Samples is set too high. Set samples to at least half the number of frames.")
    return()
  }
  rootmeansq<-function(x) {z<-sqrt(mean(x^2)); return(z)}
  
  avg<-apply(fdiff, 2, mean)
  sdev<-apply(fdiff, 2, sd)
  rms<-apply(fdiff, 2, rootmeansq)
  activity<-NULL
  Fs<-1/median(as.numeric(diff(extract.times))) 
  # sample rate in frames per sec (images captures every 1/Fs seconds)
  activity<-cbind(avg,sdev,rms)
  no.cols<-ncol(activity)
  colnames(activity)<-c("cAvgDiff", "cSDDiff", "cRMSDiff")
  rownames(activity)<-c(seq(1,nrow(activity),1))
  cumsum.act<-apply(activity,2,cumsum)
  cumsum.act<-rbind(NA, cumsum.act) ##
  # calculate the cumulative sum for each of the columns in matrix 'activity'
  # df.time<-seq(1/Fs,nrow(cumsum.act)/Fs,1/Fs)
  df.time<-c(0,cumsum(as.numeric(diff(extract.times))))
  # construct actual time index from the est.times variable used earlier during header extraction
  df.times<-extract.times[1:length(extract.times)] ##
  # real time stamps
  frame.no<-seq(1, length(df.times), 1)
  matplot(df.time, cumsum.act, type = "l",  lty=c(1,1), lwd=1, xlab="Time (s)", ylab="Cumulative Sum",
          ylim=c(min(cumsum.act,na.rm=T), max(cumsum.act,na.rm=T)), xlim=c(min(df.time,na.rm=T),max(df.time,na.rm=T)))
  legend("topleft", bty = "n", c("cAvgDiff", "cSDDiff", "cRMSDiff"), lty=c(1,1), col=c("black", "red", "green"))
  # plot the cumulative function 
  
  rawresult<-data.frame( RealTime=df.times, ElapTime=df.time, Frame=frame.no, cumsum.act)
  
  slp.av<-slopeEveryN(rawresult$cAvgDiff, samples)*Fs
  slp.sd<-slopeEveryN(rawresult$cSDDiff, samples)*Fs
  slp.rms<-slopeEveryN(rawresult$cRMSDiff, samples)*Fs
  frame.samp<-meanEveryN(rawresult$Frame, samples)
  slp.av<-slp.av[,-1]
  slp.sd<-slp.sd[,-1]                                   
  slp.rms<-slp.rms[,-1]
  # remove the 1st column before binding
  slp<-data.frame(frame.samp, slp.av,slp.sd, slp.rms)    
  # bind slp.av and slp.sd: slopes taken every n samples
  colnames(slp)<-c("Frame", "SlpAvg", "SlpSD", "SlpRMS")
  # df time variables refers to the frame differences. 
  # time variables refer to absolute clock time
  # time.s or time.m refer to elapsed time in seconds or minute
  dfsec<-seq(from = 1/Fs, to = length(rawresult$RealTime)/Fs, by = 1/Fs)
  dfmin<-dfsec/60                     # convert times to minutes
  samp.times<-meanEveryN(rawresult$RealTime, samples)
  samp.times<-as.POSIXct(samp.times, origin="1970-01-01")  # extracted real times at sample rate
  samp.sec<-meanEveryN(dfsec,samples)
  samp.min<-samp.sec/60
  
  sloperesult<-data.frame(RealTime=samp.times, ElapTime=samp.sec, slp)
  
  matplot(sloperesult$ElapTime, sloperesult[,4:6], type = "l",  lty=c(1,1), lwd=1, xlab="Time (s)", ylab="Slope of Cumulative Sum",
          ylim=c(min(sloperesult[,4:6], na.rm=T), max(sloperesult[,4:6], na.rm=T)), xlim=c(min(sloperesult$ElapTime, na.rm=T),max(sloperesult$ElapTime,na.rm=T)))
  legend("topleft", bty = "n", c("Avg", "SD", "RMS"), lty=c(1,1), col=c("black", "red", "green"))
  
  result<-list(rawdiff=rawresult, slopediff=sloperesult)
  return(result)
}
