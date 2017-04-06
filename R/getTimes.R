#' @export
#' 
getTimes<-function(vidfile, headstarts, timestart=448, byte.length=2)
  {
  save.time<-strptime(file.info(vidfile)$mtime,"%Y-%m-%d %H:%M:%OS")
  # time at which the file was saved.  this almost corresponds to the last frame of the file 
  # compare to dateOriginal from exiftool
  
  to.read <- file(vidfile, "rb") # set to.read file.  rb means read binary
  seek(to.read,where=(headstarts+timestart)*byte.length, origin="start")
  timeplace<-readBin(to.read, integer(), n=3, size=byte.length, endian = "little", signed=FALSE)
  close(to.read)
  
  # thus: 452nd byte contains msec, 450th contains sec, 451st contains day info
  # timeplace[2] = dayplace, timeplace[1]=secplace, timeplace[3]=msecplace
  
  options(digits.secs=3)
  hex.time.day<-as.hexmode(timeplace[2])
  hex.time.sec<-as.hexmode((timeplace[1]))
  time.char<-paste("0x",hex.time.day, hex.time.sec, sep="")
  time.num<-as.numeric(time.char)+timeplace[3]/1000
  extract.times<-as.POSIXct(time.num, origin="1970-01-01")
  rownames(extract.times)<-NULL
  return(extract.times)
}
