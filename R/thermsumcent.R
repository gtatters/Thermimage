#' @export
#' 
thermsumcent<-function(dat, templookup=NULL, w=640, h=480, boxsize=0.05)
  {
  # supply dat as a vector
  if(!is.null(templookup)) dat<-templookup[dat]
  
  dat<-matrix(dat, nrow=w, ncol=h)
  centre.point<-dat[floor(w/2), floor(h/2)]
  # Centre.point is equivalent to the centre spot ROI typical of FLIR images.
  centre.box<-matrix(dat[seq(w/2-boxsize*w, w/2+boxsize*w,1),
                         seq(h/2-boxsize*h,h/2+boxsize*h,1)])
  centre.box<-dat[-c(1:(w/2-boxsize*w), (w/2+boxsize*w):w), 
                  -c(1:(h/2-boxsize*h), (h/2+boxsize*h):h)]
  centre.box.min<-min(centre.box, na.rm=T)
  centre.box.max<-max(centre.box, na.rm=T)
  centre.box.mean<-mean(centre.box, na.rm=T)
  centre.box.sd<-stats::sd(centre.box, na.rm=T)
  centre.box.median<-stats::median(centre.box, na.rm=T)
  result<-c(CentrePoint=centre.point, CentreBoxMin=centre.box.min, CentreBoxMax=centre.box.max,
            CentreBoxMean=centre.box.mean, CentreBoxSD=centre.box.sd, CentreBoxMedian=centre.box.median)
  return(result)
}
