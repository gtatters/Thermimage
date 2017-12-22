#' @export
#'
ffmpegcall<-function(filenameroot, filenamesuffix="%05d", filenameext="jpegls", incompresstype="jpegls", fr=30, res.in="640x480", 
                      res.out=res.in, outputcompresstype="png", outputfilenameroot=NULL, outputfiletype="avi", outputfolder="output",...){
 
   # for use on a folder of numbered images, use "filename%05d.jpegls" to perform on all images
  
  if(!dir.exists(outputfolder)) dir.create(outputfolder)
  
  filename<-paste0(filenameroot, filenamesuffix, ".", filenameext)
  
  if(is.null(outputfilenameroot)) {
    filename.png<-paste0(outputfolder, "/", gsub(filenameext, "png", filename))
    filename.avi<-paste0(outputfolder, "/", filenameroot, ".avi")
  }
  if(!is.null(outputfilenameroot)){
    filename.png<-paste0(outputfolder, "/", outputfilenameroot, "%05d", ".png")
    filename.avi<-paste0(outputfolder, "/", outputfilenameroot, ".avi")
  }
  
  if(outputfiletype=="png"){
    # ffmpeg -f image2 -vcodec jpegls -i frame%05d.jpegls -f image2 -vcodec png frame%05d.png -y
    args=c("-f", "image2", "-vcodec", incompresstype, "-s", res.in, "-i", shQuote(filename), "-f", "image2", "-vcodec", "png",  "-s", res.out, shQuote(filename.png), "-y")
    system2('ffmpeg', args=args, stdout=TRUE)
  }
  if(outputfiletype=="avi"){
    # ffmpeg -r 30 -f image2 -vcodec jpegls -s 1024x768 -i frame%05d.jpegls -vcodec png -s 1024x768 frame.avi -y
    args=c("-r", fr, "-f", "image2", "-vcodec", incompresstype, "-s", res.in, "-i", shQuote(filename), "-vcodec", outputcompresstype,  "-s", res.out, shQuote(filename.avi), "-y")
    system2('ffmpeg', args=args, stdout=TRUE)
  }
}

