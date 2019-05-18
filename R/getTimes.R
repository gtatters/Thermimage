#' @export
#' 
getTimes<-function(vidfile, headstarts, timestart=900, byte.length=1)
{
  options("digits.secs"=3)
  save.time<-strptime(file.info(vidfile)$mtime,"%Y-%m-%d %H:%M:%OS")
  # time at which the file was saved.  this almost corresponds to the last frame of the file 
  # compare to dateOriginal from exiftool
  
  # 905-906 byte contains msec, 900-902 contains sec, 903-904 contains day info
  # timeplace[2] = dayplace, timeplace[1]=secplace, timeplace[3]=msecplace
  
  to.read <- file(vidfile, "rb") # set to.read file.  rb means read binary
  seek(to.read, where=headstarts+timestart, origin="start")
  timeplace<-readBin(to.read, raw(), n=6, size=byte.length)
  close(to.read)
  
  # Native Order from hex fiend:
  # 45F9 745C 6F01 0000 20FE
  # 63813 23668   367   (little endian converted from Thermimage current integer conversion)
  # sec   day  msec ____ timezone
  
  to.read <- file(vidfile, "rb") 
  seek(to.read, where=headstarts+timestart+8, origin="start")
  timezone<-readBin(to.read, integer(), n=1, size=2, signed=TRUE)
  close(to.read)
  
  # timezone info is 8 bytes ahead of date/time original
  # expressed as +- hours UTC

  timezone=-1*timezone/60
  timezone.minute=60*(timezone-floor(timezone))
  timezone.hour=floor(timezone)
  if(timezone<0) signval="-"
  if(timezone>=0) signval="+"
  tz<-paste0(signval, formatC(abs(timezone.hour), width=2, flag="0"), 
            formatC(timezone.minute, width=2, flag="0"))
  
  hex.time.day<-as.character(timeplace[4:3]) # bytes are little endian so need to switch
  hex.time.sec<-as.character(timeplace[2:1]) # bytes are little endian so need to switch
  hex.time.msec<-as.character(timeplace[6:5]) # bytes are little endian so need to switch
  
  time.char<-paste0("0x", paste0(c(hex.time.day, hex.time.sec), collapse=""), collapse="")
  msec.char<-paste0( paste0(c("0x",hex.time.msec, collapse="")), collapse="")
  # time.char is the number of seconds since 1970
  
  time.num<-as.numeric(time.char) + as.numeric(msec.char)/1000
  extract.times<-as.POSIXct(time.num, origin="1970-01-01")
  
  #extract.times<-paste0(as.character(as.POSIXct(time.num, origin="1970-01-01")), tz)
  #extract.times<-as.POSIXct(extract.times, format="%Y-%m-%d %H:%M:%OS%z")
  
  extract.times<-paste0(as.character(extract.times), tz)
  rownames(extract.times)<-NULL
  
  return(extract.times)
}
