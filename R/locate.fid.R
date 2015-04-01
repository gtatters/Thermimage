locate.fid<-function(fid,data)
{
  fid.rev<-rev(fid)       
  data.embed<- embed(data,length(fid)) 
  s<-which(rowSums(data.embed == rep(fid.rev, each=nrow(data.embed))) == ncol(data.embed)) 
}