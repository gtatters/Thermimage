#' @export
#' 
forcedparameters<-function(V=1, L=0.1, Ta=20, shape="hcylinder"){
  # shape can be "sphere", "hplate", "vplate", or "hcylinder" or "vcylinder"
  # the letter v or h denotes vertical or horizontal orientation but is only used in the free
  # parameters call
  Re<-Reynolds(V, L, airviscosity(Ta))  
  
  #shape[which(shape=="vplate" | shape=="hplate")]<-"plate"
  #shape[which(shape=="vcylinder" | shape=="hcylinder")]<-"cylinder"
  
  c<-rep(NA, length(shape))
  n<-rep(NA, length(shape))
  
  ind<-shape=="hplate" | shape=="vplate"
    c[ind]<-0.595; n[ind]<-0.5
  ind<-shape=="sphere"
    c[ind]<-0.37; n[ind]<-0.6

  # Table from Gates, 2003 to recalculate c and n given Reynolds number
  ind<-(shape=="hcylinder" | shape=="vcylinder") & (Re >= 0.4 & Re <4.0)
    c[ind]<-0.891;  n[ind]<-0.33
  ind<-(shape=="hcylinder" | shape=="vcylinder") & (Re >= 4 & Re <40.0)
    c[ind]<-0.821;  n[ind]<-0.385
  ind<-(shape=="hcylinder" | shape=="vcylinder") & (Re >= 40 & Re <4000)
    c[ind]<-0.615;  n[ind]<-0.466
  ind<-(shape=="hcylinder" | shape=="vcylinder") & (Re >= 4000 & Re <40000)
    c[ind]<-0.174;  n[ind]<-0.618
  ind<-(shape=="hcylinder" | shape=="vcylinder") & (Re >= 40000 & Re <400000)
    c[ind]<-0.024;  n[ind]<-0.805
  
  coeffs<-list(c,n)
  names(coeffs)<-c("c","n")
  coeffs
}
