#' @export
#' 
writeFlirBin<-function(bindata, templookup=NULL, w, h, Interval, rootname)
  {
  # bindata should be supplied as a vector
  
  nf<-length(bindata)/w/h # quick count of the number of frames to be exported 
  binaryfilename<-paste0(rootname, "_W", w, "_H", h, "_F", nf, "_I", Interval, ".raw")
  if(is.null(templookup)){
    temperature=bindata
  }
  if(!is.null(templookup)){
    temperature<-templookup[bindata]
  }
  
  wb<-file(binaryfilename, "wb")
  writeBin(temperature, wb, size=4, endian="little") 
  close(wb)
 
}

