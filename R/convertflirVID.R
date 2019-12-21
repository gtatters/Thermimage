#' @export
#'
convertflirVID<-function(imagefile, exiftoolpath="installed", perlpath="installed", fffsplitpattern="fff",
                         fr=30, res.in="1024x768", res.out="1024x768", outputcompresstype="jpegls", 
                         outputfilenameroot=NULL, outputfiletype="avi", outputfolder="output", verbose=FALSE, ...){
  
  if(is.null(outputfilenameroot)) outputfilenameroot<-paste0(gsub("input/","",imagefile))
  
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
  # Consider fixing and drawing from my generic split.pl script with following syntasx:
  # perl split -i filename -o outputfoldername -b basename -p fffsplitpattern -x outputfileextension -s skip -v verbose
  
  # so, normally fff should split properly, but some SEQ files seem to purposely have
  # extra FFF headers (presumably to confuse matters), so fffsplitpattern should be set to "seq"
  
  fffsplitpattern<-tolower(fffsplitpattern)
  perlvalsfff<- c(paste0(system.file(package = "Thermimage"), "/perl/split.pl"), "-i", shQuote(imagefile),
                  "-o", "temp", "-b", "frame", "-p", fffsplitpattern, "-x", "fff")
  
  # Split thermalvid.raw file based on jpegls tags: 
  perlvalsjpegls<- c(paste0(system.file(package = "Thermimage"), "/perl/split.pl"), "-i", "temp/thermalvid.raw",
                     "-o", "temp", "-b", "frame", "-p", "jpegls", "-x", "jpegls")
  
  
  # Split thermalvid.raw file based on TIFF tags (use this on thermalvid.raw): perl -f split_tiff.pl < thermalvid.raw
  perlvalstiff<- c(paste0(system.file(package = "Thermimage"), "/perl/split.pl"), "-i", "temp/thermalvid.raw",
                   "-o", "temp", "-b", "frame", "-p", "tiff", "-x", "tiff")
  
  # Define the various exiftool arguments ####
  # Extract Binary data: exiftool -b -RawThermalImage filename.fff  > filename.raw
  exifvalsrawunix<-c("-RawThermalImage", "-b", "temp/*.fff", ">", "temp/thermalvid.raw")
  exifvalsrawpc<-paste0("-RawThermalImage ", "-b ",  shQuote(paste0(getwd(), "/temp/*.fff"), type="cmd"))
  
  #exifvalsdate<-paste0("-DateTimeOriginal", " ", "temp/*.fff", "| grep 'Date/Time Original' | cut -d: -f2 -f3 -f4 -f5 -f6 -f7 -f8")
  exifvalsdate<-paste0("-DateTimeOriginal", " ", "-q", " ", "temp/*.fff")
  # Framerates: "exiftool -DateTimeOriginal *.fff"  
  
  if(verbose==TRUE){
    cat("\nBreak video into .fff files into temp folder using:")
    cat("\n")
    cat(paste(c(perl, perlvalsfff), sep=" ", collapse=" "))
    cat("\n")
  }
  
  # break video into .fff files into temp folder (inside of working folder):
  info <- system2(perl, args = paste0(perlvalsfff, collapse = " "), stdout = TRUE)
  
  times <- system2(exiftool, args = exifvalsdate, stdout = TRUE)
  nf <- length(times)
  
  # display frame times to screen derived from .fff files
  if(verbose==TRUE) {
    cat(paste0("\n\nVideo split into ", nf, " fff frames in temp folder\n"))
    cat("\nVideo frame times:\n")
    print(times)
  }
  
  # put raw thermal data from fff into one thermalvid.raw file in temp folder:
  if (Sys.info()["sysname"]=="Darwin" | Sys.info()["sysname"]=="Linux")
  {
    if(verbose==TRUE){
      cat("\n")
      cat("Put binary raw thermal data from fff into one thermalvid.raw file in temp folder using:")
      cat("\n")
      cat(paste(c(exiftool, exifvalsrawunix), sep=" ", collapse=" "))
    }
    info <- system2(exiftool, args=exifvalsrawunix, stdout="")
    if(verbose==TRUE){
      cat("\n\nfff files merged into thermalvid.raw file in temp folder.\n")
      cat("\n")
    }
  }
  
  if (Sys.info()["sysname"]=="Windows")
  {
    if(verbose==TRUE){
      cat("\n")
      cat("Put binary raw thermal data from fff into one thermalvid.raw file in temp folder using:")
      cat("\n")
      cat(paste(c(exiftool, exifvalsrawpc, "> temp/thermalvid.raw"), sep=" ", collapse=" "))
      cat("\n")
    }
    info <- system2(exiftool, args=exifvalsrawpc, stdout="temp/thermalvid.raw")
    if(verbose==TRUE){
      cat("\n\nfff files merged into thermalvid.raw file in temp folder. \n")
      cat("\n")
    }
  }
  
  if(file.ext==".csq"){
    # break thermalvid.raw video into .jpegls files in temp folder:
    if(verbose==TRUE){
      cat("\n")
      cat("Break thermalvid.raw video into separate files in temp folder using:\n")
      cat("\n")
      cat(paste(c(perl, perlvalsjpegls), sep=" ", collapse=" "))
      cat("\n")
    } 
    info <- system2(perl, args = perlvalsjpegls, stdout = "")
    
    if(verbose==TRUE) cat("\n\nthermalvid.raw file has been split into jpegls files in temp folder. \n")
    
    # If CSQ files to be converted into png or avi:
    if(verbose==TRUE) cat("\n\nConvert files with ffmpeg using:\n\n")
    ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="jpegls", incompresstype="jpegls", fr=fr, res.in=res.in, res.out=res.out,
               outputcompresstype=outputcompresstype, outputfilenameroot=outputfilenameroot, outputfiletype=outputfiletype, outputfolder=outputfolder)
    # 
    # ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="jpegls", incompresstype="jpegls", fr=30, res.in="1024x768",
    #             outputfilenameroot=paste0(gsub("input/","",imagefile)), outputfiletype="png", res.out="1024x768", outputcompresstype="png")
  }
  
  if(file.ext==".seq"){
    # break thermalvid.raw video into .tiff files in temp folder:
    if(verbose==TRUE) {
      cat("\n")
      cat("Break thermalvid.raw video into separate files in temp folder using:\n")
      cat(paste(c(perl, perlvalstiff), sep=" ", collapse=" "))
    }
    info <- system2(perl, args = perlvalstiff, stdin = "")
    
    if(verbose==TRUE) cat("\n\nthermalvid.raw file has been split into tiff files in temp folder. \n")
    
    # If SEQ files to be converted into png or avi:
    if(verbose==TRUE) cat("\n\nConvert files with ffmpeg using:\n\n")
    ffmpegcall(filenameroot="temp/frame", filenamesuffix="%05d", filenameext="tiff", incompresstype="tiff", fr=fr, res.in=res.in, res.out=res.out, 
               outputcompresstype=outputcompresstype, outputfilenameroot=outputfilenameroot, outputfiletype=outputfiletype, outputfolder=outputfolder)
    
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
  
  if (Sys.info()["sysname"]=="Darwin" | Sys.info()["sysname"]=="Linux"){
    if(file.exists("./temp")) file.remove("./temp")
  }
  
  if (Sys.info()["sysname"]=="Windows"){
    if(file.exists("./temp")) unlink('./temp', recursive=TRUE)
  }
  
  
}
