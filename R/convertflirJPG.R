#' @export
#'
convertflirJPG<-function(imagefile, exiftoolpath="installed", res.in="640x480", endian="lsb", 
                         outputfolder="output", ...){
  
  if (!exiftoolpath == "installed") {
    exiftoolcheck <- paste0(exiftoolpath, "/exiftool")
    if (!file.exists(exiftoolcheck)) {
      stop("Exiftool not installed at this location.  Please check path usage.")
    }
  }
  
  if (exiftoolpath == "installed") {
    exiftoolpath <- ""
  }
  
  if (Sys.info()["sysname"]=="Darwin" | Sys.info()["sysname"]=="Linux")
  {
    exiftool <- paste0(exiftoolpath, "exiftool")
  }
  
  if (Sys.info()["sysname"]=="Windows")
  {
    exiftool <- paste0(exiftoolpath, "exiftool")
  }
  

  dir.create(outputfolder, showWarnings = FALSE)
  inputfilename<-paste0(getwd(), "/", imagefile)
  outputfilename<-paste0(getwd(), "/", outputfolder, "/", gsub("input/","", gsub(".jpg", ".png", imagefile, ignore.case=TRUE)))

  exifvalsrawunix<-c(shQuote(inputfilename), "-b", "-RawThermalImage", "|", "convert", "-", "gray:-", "|", "convert", 
                     "-depth", "16", "-endian", endian, "-size", res.in, "gray:-", shQuote(outputfilename))
  
  exiftool <- paste0(exiftoolpath, "exiftool")
  
  cat(paste(c(exiftool, exifvalsrawunix), sep=" ", collapse=" "))
  
  info<-system2(exiftool, args=exifvalsrawunix, stdout=TRUE) 
  return(info)
  
  cat(info)
  cat("\n")
}
