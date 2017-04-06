#' @export
#' 
nameleadzero<-function(filenameroot="Img", filetype=".png", no.digits=5, counter=1)
  {
  leadingzeros<-no.digits-nchar(counter)
  imgname<-paste0(filenameroot, paste0(rep("0",leadingzeros), collapse=""), as.character(counter), filetype)
  return(imgname)
}

