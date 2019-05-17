#' @export
#' 
getFrames<-function(vidfile, framestarts, w=640, h=480, l=w*h, byte.length=2, reverse=FALSE,
                     magic2pixel=32)
{
  
  # framestarts refer to the magicbyte position closest to the beginning byte start
  # for raw thermal image data
  # each f.start should correspond to the magic byte start that is 
  # 32 rawbytes in front of the first pixel value
  # magic2pixel is set to be 32
  
  if(exists("reverse")==FALSE) reverse==FALSE
  
  to.read <- file(vidfile, "rb") 
  # set to.read file.  rb means read binary
  seek(to.read, where=framestarts+magic2pixel, origin="start")
  fram<-readBin(to.read, integer(), n=l, size=byte.length, endian = "little", signed=FALSE)
  close(to.read)
  
  if(reverse==TRUE){
    return(rev(fram))
  }
  if(reverse==FALSE){
    return(fram)
    
  }
}
