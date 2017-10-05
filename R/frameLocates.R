#' @export
#' 
frameLocates<-function(vidfile="", w=640, h=480, res2fram=15)
  {
  f.start<-NULL
  h.start<-NULL
  
  l<-w*h # l = number of bytes in a frame
  # File information for binary read in
  finfo <- file.info(vidfile)
  byte.length<-2  # how many bytes make up an element
  no.elements<-finfo$size/byte.length 
  # this should tell you how many total elements make up the video file
  
  to.read <- file(vidfile, "rb") # set to.read file.  rb means read binary
  alldata<-readBin(to.read, integer(), n=5000000, size=byte.length, endian = "little", signed=FALSE)
  close(to.read)
  # approx number of frames in video file, can't be certain since some headers might be different sizes
  # this value might be an over-estimate
  
  fid<-c(w,h)
  # this is the look-up sequence, starts with the magic byte 2, followed by resolution values, w, then h,
  # which will repeat throughout the file in a predicable fashion corresponding to each frame.  It is likely
  # that the number of wh locates will be double the number of actual frames, since there is a w,h at the beginning
  # and the end of every frame.
  
  if(length(alldata)>=5000000)
  {
    wh.locate<-locate.fid(fid,alldata,long=TRUE)
    # try wh.locate on a small chunk of all data
    diff.wh.locate<-diff(wh.locate) 
    # difference calc should yield a repeating pattern of header then frame
    gaps<-unique(diff.wh.locate)
    # if the pattern is simple, this value should be 2
    no.unique.locates<-length(gaps) 
    # reconstruct wh.locate from scrap, starting only with wh.locate[1]
    
    if(no.unique.locates==2)
    {
      repeats<-trunc(finfo$size/2/(l+wh.locate[1]+gaps[1]))
      # how many repeats required to create fill whole file
      wh.locate<-cumsum(as.numeric((c(wh.locate[1],rep(gaps,repeats)))))
      # cumulative sum up the 1st locate and repeate gaps
      wh.locate<-(wh.locate[-c(which(wh.locate>(finfo$size/byte.length)))])
      # remove any locates that go beyond the length of the data file after import
      header.l<-as.integer(rev(wh.locate)[1]-rev(wh.locate)[2])
    }
    if(no.unique.locates==4)
    {
      repeats<-trunc((finfo$size/byte.length)/(l))
      gap.reps<-rep(gaps[3:4],repeats)
      wh.locate<-cumsum(as.numeric((c(wh.locate[3],gap.reps))))
      wh.locate<-(wh.locate[-c(which(wh.locate>(finfo$size/byte.length)))])
      header.l<-as.integer(rev(wh.locate)[2]-rev(wh.locate)[3])
    }
  }
  
  if(length(alldata)<5000000)
  {
    # much faster without calling my function:
    fid1.locate<-which(alldata==fid[1])
    fid1.locate.adjacent<-fid1.locate+1
    fid2.locate<-which(alldata[c(fid1.locate.adjacent)]==fid[2])
    wh.locate<-fid1.locate[fid2.locate]
    
    diff.wh.locate<-diff(wh.locate) 
    # difference calc should yield a repeating pattern of header then frame
    gaps<-unique(diff.wh.locate)
    # if the pattern is simple, this value should be 2
    no.unique.locates<-length(unique(diff.wh.locate)) 
    # if the pattern is simple, this value should be 2
    header.l<-as.integer(rev(wh.locate)[1]-rev(wh.locate)[2])
  }
  
  # Below define the start indices for the headers (h.start) and frames (f.start)
  # check if the first location of the resolution info is a small value or not
  # .SEQ files have two instances where resolution is recorded 
  # .FCF files only have it once toward the end of the header
  
  if(wh.locate[1]<header.l & no.unique.locates==2)  # .SEQ files appear to be formatted this way  
  {
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(2,length(h.start),2)]
    h.end<-h.start+header.l+res2fram-1
    f.start<-wh.locate+res2fram
    f.start<-f.start[seq(2,length(f.start),2)]
    f.end<-f.start+l-1
  } else if(wh.locate[1]>header.l & no.unique.locates==2) # some .fcf formatted this way
  {
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(2,length(h.start),2)]
    h.end<-h.start+header.l+res2fram-1
    f.start<-wh.locate+res2fram
    f.start<-f.start[seq(2,length(f.start),2)]
    f.end<-f.start+l-1
  } else if (wh.locate[1]>=header.l & no.unique.locates>2) 
    # other .fcf files formatted this way - there may be missed frame at beginning and end of file
  {
    wh.locate<-wh.locate[-2]
    h.start<-wh.locate-header.l
    h.start<-h.start[seq(1,length(h.start),2)]
    h.start<-h.start[2:length(h.start)]
    h.end<-h.start+header.l+res2fram-1
    f.start<-wh.locate+res2fram
    f.start<-f.start[seq(1,length(f.start),2)]
    f.start<-f.start[2:length(f.start)]
    f.end<-f.start+l-1
  } 
  
  # each f.start should correspond to the start of a frame in the video file
  # from my impression, the location of the header is 15 elements in front of the first pixel value
  # res2fram is set to be 15
  
  return(list(h.start=h.start, f.start=f.start))
}
