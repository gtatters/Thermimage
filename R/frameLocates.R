#' @export
#' 
frameLocates<-function(vidfile="", w=640, h=480)
{
  f.start<-NULL
  h.start<-NULL
  
  w.hex.be<-formatC(as.character(as.hexmode(w), width=4, format="s"))
  h.hex.be<-formatC(as.character(as.hexmode(h), width=4, format="s"))
  
  w.hex.le<-c(substr(w.hex.be, 3,4), substr(w.hex.be, 1,2))
  h.hex.le<-c(substr(h.hex.be, 3,4), substr(h.hex.be, 1,2))
  
  l<-w*h # l = number of bytes in a frame
  # File information for binary read in
  finfo <- file.info(vidfile)
  byte.length<-1  # how many bytes make up an element
  
  to.read <- file(vidfile, "rb") # set to.read file.  rb means read binary
  alldata<-readBin(to.read, raw(), n=5000000, size=1)
  close(to.read)
  # approx number of frames in video file, can't be certain since some headers might be different sizes
  # this value might be an over-estimate
  
  fid<-c("02","00", w.hex.le, h.hex.le)
  # this is the look-up sequence, starts with the magic byte 0200, followed by resolution values, w, then h,
  # which will repeat throughout the file in a predicable fashion corresponding to each frame.  It is likely
  # that the number of wh locates will be double the number of actual frames, since there is a w,h at the beginning
  # and the end of every frame.
  
  wh.locate<-locate.fid(fid, alldata, long=TRUE, zeroindex=TRUE)
  # try wh.locate on a small chunk of all data
  diff.wh.locate<-diff(wh.locate) 
  # difference calc should yield a repeating pattern of header then frame
  gaps<-unique(diff.wh.locate)
  # if the pattern is simple, this value should be 2
  no.unique.locates<-length(gaps) 
  # reconstruct wh.locate from scrap, starting only with wh.locate[1]
  
  if(no.unique.locates==2)
  {
    #repeats<-trunc(finfo$size/(l*2+wh.locate[1]+gaps[1]))
    repeats<-trunc(finfo$size/(l*2))
    
    # how many repeats required to create fill whole file
    wh.locate<-cumsum(as.numeric((c(wh.locate[1],rep(gaps,repeats)))))
    # cumulative sum up the 1st locate and repeat gaps
    
    header.l<-0
  }
  if(no.unique.locates==4)
  {
    repeats<-trunc(finfo$size/(l))
    gap.reps<-rep(gaps[3:4],repeats)
    wh.locate<-cumsum(as.numeric((c(wh.locate[3],gap.reps))))
    wh.locate<-(wh.locate[-c(which(wh.locate>(finfo$size/byte.length)))])
    header.l<-as.integer(rev(wh.locate)[2]-rev(wh.locate)[3])
  }
  
  # Below define the start indices for the headers (h.start) and frames (f.start)
  # check if the first location of the resolution info is a small value or not
  # .SEQ files have two instances where resolution is recorded 
  
  if( no.unique.locates==2)  # .SEQ files appear to be formatted this way  
  {
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(1, length(h.start), 2)] # changed to extract 1st index, error had this as 2nd?
    h.start<-h.start[!h.start>=(finfo$size)] # remove any location beyond file size
    
    f.start<-wh.locate
    f.start<-f.start[seq(2,length(f.start),2)]
    f.start<-f.start[!f.start>=(finfo$size-l)] # remove any location beyond file size
    
  } else if(wh.locate[1]>header.l & no.unique.locates==2) 
  {
    # some .fcf formatted this way - warning limited support for fcf files
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(1,length(h.start),2)]
    h.start<-h.start[-which(h.start>=finfo$size)] # remove any location beyond file size
    
    f.start<-wh.locate
    f.start<-f.start[seq(2,length(f.start),2)]
    f.start<-f.start[-which(f.start>=finfo$size-l)] # remove any location beyond file size
    
  } else if (wh.locate[1]>=header.l & no.unique.locates>2) 
    # other .fcf files formatted this way - there may be missed frame at beginning and end of file
  {
    wh.locate<-wh.locate[-2]
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(1,length(h.start),2)]
    h.start<-h.start[2:length(h.start)]
    f.start<-wh.locate
    f.start<-f.start[seq(1,length(f.start),2)]
    f.start<-f.start[2:length(f.start)]
  } 
  
  # each f.start should correspond to the start of a frame in the video file
  # from my impression, the location of the header is 32 rawbytes in front of the first pixel value
  # res2fram is set to be 32
  
  return(list(h.start=h.start, f.start=f.start))
}
