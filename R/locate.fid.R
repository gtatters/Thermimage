#' @export
#' @importFrom stats embed
#' 
locate.fid<-function(fid, vect, long=TRUE, zeroindex=TRUE)
{
  if(long==FALSE)
  {
    # perform a which subset check for each element in fid
    ind<-NULL
    ind.temp<-NULL
    output<-NULL
    maxlen<-length(vect)
    for (i in 1:2)
    {
      temp<-which(vect==fid[i])
      if(length(temp)<maxlen) maxlen<-length(temp)
      ind.temp<-matrix(temp)
      ind<-cbind(ind,ind.temp[1:maxlen])
    }
    matches<-ind[,2]-ind[,1]==1
    if(all(matches)) output<-ind[,1]
    if(all(matches)==FALSE) output<-NULL
  }
  
  if(long==TRUE)
  {
   fid.rev<-rev(fid)       
   vect.embed<- embed(vect,length(fid))
   output<-which(rowSums(vect.embed == rep(fid.rev, each=nrow(vect.embed))) == ncol(vect.embed)) 
  }
  if(zeroindex==TRUE){
    return(output-1)
  }
  if(zeroindex==FALSE){
    return(output)
  }
}
