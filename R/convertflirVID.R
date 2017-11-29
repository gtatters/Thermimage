#' @export
#'
convertflirVID<-function(imagefile, exiftoolpath="installed", perlpath="installed",
                         fr=30, res.in="1024x768", res.out="1024x768", outputcompresstype="jpegls", 
                         outputfilenameroot=NULL, outputfiletype="avi", outputfolder="output", ...){
  
  if (!exiftoolpath == "installed" | !perlpath=="installed") {
    exiftoolcheck <- paste0(exiftoolpath, "/exiftool")
    perlcheck <- paste0(perlpath, "/exiftool")
    
    if (!file.exists(exiftoolcheck)) {
      stop("Exiftool not installed at this location.  Please check path usage.")
    }
    if (!file.exists(perlcheck)) {
      stop("Perl not installed at this location.  Please check path usage.")
    }
  }
  
  if (exiftoolpath == "installed") {
    exiftoolpath <- ""
    #exiftoolpath<-"c:\\Windows\\"
  }
  
  if (perlpath == "installed") {
    perlpath <- ""
    #perlpath<-"c:\\Windows\\Dwimperl\\perl\\bin\\"
  }
  
  if (Sys.info()["sysname"]=="Darwin" | Sys.info()["sysname"]=="Linux")
  {
    perl<-paste0(perlpath, "perl")
    exiftool <- paste0(exiftoolpath, "exiftool")
  }
  
  if (Sys.info()["sysname"]=="Windows")
  {
    perl<- "perl.exe "
    exiftool <- paste0(exiftoolpath, "exiftool")
  }
  
  file.ext<-tolower(substr(imagefile, regexpr("\\.([[:alnum:]]+)$", imagefile), nchar(imagefile)))
  
  # Define the various perl arguments ####
  # Split file based on FFF tags: perl -f split_fff.pl filename.csq:                 
  pervalsfff<- c("-f", paste0(system.file(package = "Thermimage"), "/perl/split_fff.pl"), shQuote(imagefile))
  
  # Split file based on jpegls tags: perl -f split_jpegls.pl filename.raw:
  perlvalsjpegls<- c("-f", paste0(system.file(package = "Thermimage"), "/perl/split_jpegls.pl"), "temp/thermalvid.raw") 
  
  # Split file based on TIFF tags: perl -f split_tiff.pl < filename.raw
  perlvalstiff<- c("-f", paste0(system.file(package = "Thermimage"), "/perl/split_tiff.pl"), "<", "temp/thermalvid.raw")                   
  
  
  # Define the various exiftool arguments ####
  # Extract Binary data: exiftool -b -RawThermalImage filename.fff  > filename.raw
  exifvalsrawunix<-c("-RawThermalImage", "-b", "temp/*.fff", ">", "temp/thermalvid.raw")
  #exifvalsrawpc<-paste0("-RawThermalImage ", "-b ",  shQuote(paste0(getwd(), "/temp/*.fff"), type="cmd"), " > ", shQuote(paste0(getwd(), "/temp/thermalvid.raw"), type="cmd"))
  
  exifvalsdate<-paste0("-DateTimeOriginal", " ", "temp/*.fff", "| grep 'Date/Time Original' | cut -d: -f2 -f3 -f4 -f5 -f6 -f7 -f8")
  # Framerates: "exiftool -DateTimeOriginal *.fff"  
  
  cat("\n")
  cat(paste(c(perl, pervalsfff), sep=" ", collapse=" "))
  # break video into .fff files into temp folder (inside of working folder):
  info <- system2(perl, args = pervalsfff, stdout = "")
  cat("\n\nVideo split into fff frames in temp folder\n")
  
  # display frame times to screen derived from .fff files
  cat("\nVideo frame times:\n")
  info <- system2(exiftool, args = exifvalsdate, stdout = "")
 
  # put raw thermal data from fff into one thermalvid.raw file in temp folder:
  if (Sys.info()["sysname"]=="Darwin" | Sys.info()["sysname"]=="Linux")
  {
    cat("\n")
    cat(paste(c(exiftool, exifvalsrawunix), sep=" ", collapse=" "))
    info <- system2(exiftool, args=exifvalsrawunix, stdout="")
    cat("\n\nfff files merged into thermalvid.raw file in temp folder. \n")
    cat("\n")
  }
  
  if (Sys.info()["sysname"]=="Windows")
  {
    cat("\n")
    cat(paste(c(exiftool, exifvalsrawunix), sep=" ", collapse=" "))
    info <- system2(exiftool, args=exifvalsrawunix, stdout="")
    cat("\n\nfff files merged into thermalvid.raw file in temp folder. \n")
    cat("\n")
  }
  
  if(file.ext==".csq"){
    # break thermalvid.raw video into .jpegls files in temp folder:
    cat(paste(c(perl, perlvalsjpegls), sep=" ", collapse=" "))
    info <- system2(perl, args = perlvalsjpegls, stdout = "")
    cat("\n\nthermalvid.raw file split into jpegls files in temp folder. \n\n")
    
    # If CSQ files to be converted into png or avi:
    ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="jpegls", incompresstype="jpegls", fr=fr, res.in=res.in, res.out=res.out,
               outputcompresstype=outputcompresstype, outputfilenameroot=paste0(gsub("input/","",imagefile)), outputfiletype, outputfolder=outputfolder)
    # 
    # ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="jpegls", incompresstype="jpegls", fr=30, res.in="1024x768",
    #             outputfilenameroot=paste0(gsub("input/","",imagefile)), outputfiletype="png", res.out="1024x768", outputcompresstype="png")
  }
  
  if(file.ext==".seq"){
    # break thermalvid.raw video into .tiff files in temp folder:
    cat(paste(c(perl, perlvalstiff), sep=" ", collapse=" "))
    info <- system2(perl, args = perlvalstiff, stdout = "")
    cat("\n\nthermalvid.raw file split into tiff files in temp folder. \n\n")
    
    # If SEQ files to be converted into png or avi:
    ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="tiff", incompresstype="tiff", fr=fr, res.in=res.in, res.out=res.out, 
               outputcompresstype=outputcompresstype, outputfilenameroot=paste0(gsub("input/","",imagefile)), outputfiletype="avi", outputfolder=outputfolder)
    
    # ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="tiff", incompresstype="tiff", fr=30, res.in="640x480",
    #             outputfilenameroot=paste0(gsub("input/","",imagefile)), outputfiletype="png", res.out="640x480", outputcompresstype="png")
  }
  
  # Clean up temp folder (created by perl scripts)
  file.remove(list.files(path="./temp", pattern="\\.fff$", full.names=TRUE, ignore.case=TRUE, recursive=TRUE))
  file.remove(list.files(path="./temp", pattern="\\.jpegls$", full.names=TRUE, ignore.case=TRUE, recursive=TRUE))
  file.remove(list.files(path="./temp", pattern="\\.tiff$", full.names=TRUE, ignore.case=TRUE, recursive=TRUE))
  file.remove(list.files(path="./temp", pattern="thermalvid.raw", full.names=TRUE, ignore.case=TRUE, recursive=TRUE))
  
  # Just delete the temp folder creator
  # file.size(list.dirs()[list.dirs()=="./temp"])
  if(file.exists("./temp")) file.remove("./temp")
  
  
}
