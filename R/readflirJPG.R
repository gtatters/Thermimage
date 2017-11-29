#' @export
#' 
readflirJPG<-function(imagefile,  exiftoolpath="installed")
{
  # source: http://timelyportfolio.github.io/rCharts_catcorrjs/exif/
  # see also here for converting thermal image values
  # http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=4898.45
  # http://130.15.24.88/exiftool/forum/index.php?topic=4898.90
  # Accessing exiftool and convert from system command line 
  # Decipher Camera Meta Data information 
  # Need to have exiftool installed in your OS's system folder or equivalent
  # http://www.sno.phy.queensu.ca/~phil/exiftool/
  # Imagemagick source (redundant now, but was used with convert call):
  # http://cactuslab.com/imagemagick/
  # v. 2.2.3 fixed error in readflirJPG on a windows OS. 
  # Credit to John Al-Alawneh for troubleshooting
 
  if (!exiftoolpath == "installed") {
    exiftoolcheck <- paste0(exiftoolpath, "/exiftool")
    if (!file.exists(exiftoolcheck)) {
      stop("Exiftool not installed at this location.  Please check path usage.")
    }
  }
  
  if (exiftoolpath == "installed") {
    exiftoolpath <- ""
  }
  
  syscommand <- paste0(exiftoolpath, "exiftool")
  vals <- paste0("-b > tempfile")
  
  
  if (Sys.info()["sysname"]=="Darwin")
  {
    info <- system2(syscommand, args = paste0(shQuote(imagefile)," ", vals), stdout = "")
  } 
  
  if (Sys.info()["sysname"]=="Linux")
  {
    info <- system2(syscommand, args = paste0(shQuote(imagefile)," ", vals), stdout = "")
  }
  if (Sys.info()["sysname"]=="Windows")
  {
    info <- shell(paste(syscommand,imagefile,vals))
  }
  
  if (exiftoolpath == "") {
    exiftoolpath <- "installed"
  }
  
  cams <- flirsettings(imagefile, exiftoolpath, camvals = "")
  
  currentpath <- getwd()
  to.read <- file("tempfile", "rb")
  alldata <- readBin(to.read, raw(), n = file.info("tempfile")$size)
  close(to.read)
  if (cams$Info$RawThermalImageType == "TIFF") {
    TIFF <- Thermimage::locate.fid(c("54", "49", "46", "46","49", "49"), alldata)
    if (length(TIFF) == 1) {
      alldata <- alldata[-c(1:(TIFF + 3))]
      
      to.write <- file("tempfile", "wb")
      writeBin(alldata, to.write)
      close(to.write)
      img <- tiff::readTIFF(paste0(currentpath, "/tempfile"),as.is = TRUE)
      #img <- tiff::readTIFF(as.raw(alldata),as.is = TRUE) # can rem out above 4 lines
    }
  }
  if (cams$Info$RawThermalImageType == "PNG") {
    PNG <- Thermimage::locate.fid(c("89", "50", "4e", "47", "0d", "0a", "1a", "0a"), alldata)
    if (length(PNG) == 1) {
      alldata <- alldata[-c(1:(PNG - 1))]
      
      to.write <- file("tempfile", "wb")
      writeBin(alldata, to.write)
      close(to.write)
      img.reverse <- png::readPNG(paste0(currentpath, "/tempfile"))
      #img.reverse<-png::readPNG(as.raw(alldata)) # can rem out above 4 lines
      img <- (img.reverse/256 + (floor(img.reverse * (2^16 - 1))%%256)/256) * (2^16 - 1)
    }
  }
  if (file.exists("tempfile")) file.remove("tempfile")
  rm(exiftoolpath)
  return(img)
}
