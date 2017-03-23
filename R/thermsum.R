#' @export
#' 
thermsum<-function(dat, templookup=NULL)
  {
  # supply dat as a vector
  if(!is.null(templookup)) dat<-templookup[dat]
  mintemp<-min(dat, na.rm=T)
  maxtemp<-max(dat, na.rm=T)
  meantemp<-mean(dat, na.rm=T)
  sdtemp<-stats::sd(dat, na.rm=T)
  mediantemp<-stats::median(dat, na.rm=T)
  results<-c(mintemp, maxtemp, meantemp, sdtemp, mediantemp)
  names(results)<-c("Mintemp","Maxtemp","Meantemp","SDtemp","Mediantemp")
  return(results)
}
