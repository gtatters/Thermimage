#' @export
#' 
getFrames<-function(vidfile, framestarts, w=640, h=480, l=w*h, byte.length=2)
  {
  to.read <- file(vidfile, "rb") 
  # set to.read file.  rb means read binary
  seek(to.read, where=(framestarts)*byte.length-2, origin="start")
  fram<-readBin(to.read, integer(), n=l, size=byte.length, endian = "little", signed=FALSE)
  close(to.read)
  return(fram)
}
