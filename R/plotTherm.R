#' @export
#' 
plotTherm<-function(bindata, templookup=NULL, w, h, minrangeset=20, 
                    maxrangeset=40, main=NULL, thermal.palette=flirpal)
  {
  if(!is.null(templookup)) {
    d<-matrix(rev(templookup[bindata]), nrow=w, ncol=h)
  }
  else if(is.null(templookup)) {
    d<-matrix(rev(bindata), nrow=w, ncol=h)
  }
  d[which(d>maxrangeset)]<-maxrangeset
  d[which(d<minrangeset)]<-minrangeset
  d<-flip.matrix(d)
  
  # use the templookup variable, to reduce the requirement for alltemperature
  # populate temperature matrix in reverse in order to flip image before plotting 
  
  #par(pin=c(6,4.5),cex.sub=1.5, cex.main=1.5)
  
  fields::image.plot(d, useRaster=T, bty="n", col=thermal.palette, graphics.reset = T,
                     xlab="", ylab="", xaxt="n", yaxt="n", main=main, 
                     zlim=c(minrangeset,maxrangeset), 
                     legend.shrink=0.85, legend.cex=0.85, asp=h/w)
}
