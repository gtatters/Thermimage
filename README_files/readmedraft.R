library(Thermimage)
f<-paste0(system.file("extdata/IR_2412.jpg", package="Thermimage"))
img<-readflirJPG(f, exiftoolpath="installed")

cams<-flirsettings(f, exiftoolpath="installed", camvals="")
cbind(unlist(cams))

plancks<-flirsettings(f, exiftoolpath="installed", camvals="-*Planck*")
unlist(plancks$Info)
dim(img)

frameLocates(f)



cbind(unlist(cams$Dates))

str(img)
img[1,1]



Emissivity<-  cams$Info$Emissivity                    # Image Saved Emissivity - should be ~0.95 or 0.96
dateOriginal<-cams$Dates$DateTimeOriginal             # Original date/time extracted from file
dateModif<-   cams$Dates$FileModificationDateTime     # Modification date/time extracted from file
PlanckR1<-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
PlanckB<-     cams$Info$PlanckB                       # Planck B constant for camera  
PlanckF<-     cams$Info$PlanckF                       # Planck F constant for camera
PlanckO<-     cams$Info$PlanckO                       # Planck O constant for camera
PlanckR2<-    cams$Info$PlanckR2                      # Planck R2 constant for camera
OD<-          cams$Info$ObjectDistance                # object distance in metres
FD<-          cams$Info$FocusDistance                 # focus distance in metres
ReflT<-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
AtmosT<-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
IRWinT<-      cams$Info$IRWindowTemperature           # IR Window Temperature
IRWinTran<-   cams$Info$IRWindowTransmission          # IR Window transparency
RH<-          cams$Info$RelativeHumidity              # Relative Humidity
h<-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
w<-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

imgr<-flip.matrix(rotate90.matrix(img))

temperature<-raw2temp(img,Emissivity,OD,ReflT,AtmosT,IRWinT,IRWinTran,RH,
                      PlanckR1,PlanckB,PlanckF,PlanckO,PlanckR2)
str(temperature)
library(fields)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32)

# If you plot a JPG as is, it is 270 out of alignment (or -90 degrees)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix")

plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=rainbowpal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=glowbowpal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=midgreypal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=midgreenpal)

writeFlirBin(as.vector(t(temperature)), templookup=NULL, w=w, h=h, I="", rootname="FLIRjpg")





# Using Thermimage to load in and convert .SEQ and .FCF files for portability to ImageJ or other analysis 
# outside of R

library(Thermimage)

# for use with image.plot and other rasterised thermal images
thermal.palette<-palette.choose("ironbow")  # can choose form "flir","ironbow"...need to add others
ncores<-detectCores()

setwd("~/Dropbox/R/MyProjects/VideoImageActivity/data")

l.files<-list.files( full.names=F)
l.files
f<-l.files[2]
f.root<-substr(f,1,nchar(f)-4)             # text output file name root, without .rtv/seq


outputDir<-"~/Dropbox/R/MyProjects/VideoImageActivity/Output/"
outputidDir<-paste0(outputDir, f.root, "/")
dir.create(outputidDir, showWarnings = F, recursive = FALSE, mode = "0777")

pngDir<-paste0(outputidDir, "/png/")
txtimgDir<-paste0(outputidDir, "/txtimg/")


# set filename as v
v<-paste0(system.file("extdata/SampleSEQ.seq", package="Thermimage"))

# Extract camera values using Exiftool (needs to be installed)
camvals<-flirsettings(v)
w<-camvals$Info$RawThermalImageWidth
h<-camvals$Info$RawThermalImageHeight


# Create a lookup variable to convert the raw binary to actual temperature estimates, 
# use parameters relevant to experiment
suppressWarnings(
  templookup<-raw2temp(raw=1:65535, E=camvals$Info$Emissivity, OD=camvals$Info$ObjectDistance, RTemp=camvals$Info$ReflectedApparentTemperature, 
                       ATemp=camvals$Info$AtmosphericTemperature, IRWTemp=camvals$Info$IRWindowTemperature, 
                       IRT=camvals$Info$IRWindowTransmission, RH=camvals$Info$RelativeHumidity, 
                       PR1=camvals$Info$PlanckR1,PB=camvals$Info$PlanckB,PF=camvals$Info$PlanckF,PO=camvals$Info$PlanckO,PR2=camvals$Info$PlanckR2)
)
plot(templookup, type="l", xlab="Raw Binary 16 bit Integer Value", ylab="Estimated Temperature (C)")
plot(templookup, type="l", xlab="Raw Binary 16 bit Integer Value", ylab="Estimated Temperature (C)",
     xlim=c(10000,25000), ylim=c(-20,50))

templookup[c(17172, 18273, 24932)]


# find the byte place where frame and headers are found
fl<-frameLocates(v, w, h)
n.frames<-length(fl$f.start)
fl

h.start<-fl$h.start
f.start<-fl$f.start

extract.times<-NULL
library(parallel)
ncores=detectCores()
system.time(extract.times<-do.call("c", mclapply(h.start, getTimes, vidfile=v, byte.length=2, timestart=448, mc.cores=ncores)))

extract.times<-do.call("c", lapply(fl$h.start, getTimes, vidfile=v))
data.frame(extract.times)

Interval<-signif(mean(as.numeric(diff(extract.times))),3)
Interval


alldata<-NULL
alldata<-unlist(lapply(fl$f.start, getFrames, vidfile=v, w=w, h=h))
class(alldata); length(alldata)/(w*h)

system.time(alldata<-unlist(mclapply(f.start, getFrames, vidfile=v, byte.length=2, mc.cores=ncores, mc.preschedule=T)))
# create alltemperature data.frame this will be very slow with large videos
alltemperature<-NULL
system.time(alltemperature<-templookup[alldata])


library(fields)

alldata<-unname(matrix(alldata, nrow=w*h, byrow=FALSE))
alltemperature<-unname(matrix(alltemperature, nrow=w*h, byrow=FALSE))


image.plot(firstframe, useRaster=TRUE)

# frames extracted from thermal vids are upside down
plotTherm(alltemperature[,1], w=w, h=h, trans="mirror.matrix")
plotTherm(alltemperature[,2], w=w, h=h, trans="mirror.matrix")

firstframe<-matrix(alltemperature[,1], nrow=w)
image.plot(mirror.matrix(firstframe), useRaster=TRUE)


# Summary temperature data on the entire image
# Determine frame by frame min, max and mid temps
system.time(tsum<-data.frame(t(apply(alldata, 2, thermsum, templookup))))
system.time(tsum<-data.frame(t(apply(alltemperature, 2, thermsum))))

allmintemp<-mean(tsum$Mintemp)
allmaxtemp<-mean(tsum$Maxtemp)
allmeantemp<-mean(tsum$Meantemp)
allsdtemp<-mean(tsum$SDtemp)

# summary temperature data on a centre box in frame - 5% of image area
tboxsum<-data.frame(t(apply(alltemperature, 2, thermsumcent, w=w, h=h, boxsize=0.05)))
thermanalysis<-data.frame(Time=extract.times, Frame=seq(1,n.frames,1), tsum, tboxsum)

f.tsum<-paste0(f.root, "_tsummary.csv")
setwd(outputidDir)
write.csv(thermanalysis, file=f.tsum)
setwd(outputidDir)

# Successive Frame difference calculations
fdiff<-diffFrame(alltemperature, absolute=T)
cdiff<-cumulDiff(fdiff, extract.times, samples=3)
cdiff$rawdiff
cdiff$slopediff

# Put final activity data into csv files 
nf<-ncol(alltemperature) # quick count of the number of frames to be exported 
# for the analysis of frame difference analysis: nf-1
activity.output<-data.frame(cdiff$rawdiff, MinTemp=tsum$Mintemp, MaxTemp=tsum$Maxtemp, MeanTemp=tsum$Meantemp, SDTemp=tsum$SDtemp, MedianTem=tsum$Mediantemp)
resamp.output<-data.frame(cdiff$slopediff)


# Export frame differnces
setwd(outputidDir)
filename.cumuldiff.activity<-paste0(f.root, "_cumuldiff.csv")
filename.resamp.activity<-paste0(f.root, "_cumuldiff_slopes.csv")
write.csv(activity.output, filename.cumuldiff.activity)
write.csv(resamp.output, filename.resamp.activity)


# Plot video
system.time(apply(alldata, 2, plotTherm, templookup, w, h, minrangeset=allmintemp, maxrangeset=allmaxtemp))


# Export entire sequence to a raw bin for opening in ImageJ - smallish file size
setwd(outputidDir)
writeFlirBin(bindata=alldata, templookup, w, h, Interval, rootname=f.root)
setwd(outputDir)


# Export each frame as a csv file (import into ImageJ) - large files, slow to save, tedious to import into ImageJ
dir.create(txtimgDir, showWarnings = F, recursive = FALSE, mode = "0777")
setwd(txtimgDir)
for(i in 1:n.frames){
  nf<-ncol(alltemperature)
  prefix<-paste0(f.root, "_temperature")
  f.txt<-nameleadzero(prefix, filetype=".csv", no.digits=nchar(as.character(nf)), counter=i)
  
  d<-matrix(rev(alltemperature[,i]), nrow=w, ncol=h)
  d<-rotate270.matrix(d)
  d<-flip.matrix(d)
  write.csv(d, f.txt, row.names=F)
}
setwd(outputDir)



# Export each frame as a png file
dir.create(pngDir, showWarnings = F, recursive = FALSE, mode = "0777")
setwd(pngDir)
for(i in 1:n.frames){
  nf<-ncol(alltemperature)
  prefix<-paste0(f.root, "_frame_")
  f.png<-nameleadzero(prefix, filetype=".png", no.digits=nchar(as.character(nf)), counter=i)
  
  png(f.png, units="in", width=8, height=6, res=300)
  plotTherm(alltemperature[,i], templookup=NULL, w=w, h=h, tsum$mintemp[i], tsum$maxtemp[i], tsum$meantemp[i], 
            minrangeset=allmintemp, maxrangeset=allmaxtemp)
  dev.off()
  
  cat('\r',paste("Exporting #",i-1, "of", ncol(alldata), "frames", sep=" "))
}
setwd(outputDir)



setwd(outputidDir)
# Export as HTML video with folder of pngs attached
library(animation)
des = c(f)
subtitle<-paste(as.character(extract.times)," Frame #: ")
saveHTML(
  for(i in 1:ncol(alldata))
  {
    ani.options(interval = Interval, ani.width=w)
    sub.title<-paste(subtitle[i],i)
    par(pin=c(6,4.5),cex.sub=1.5, cex.main=1.5)
    plotTherm(alldata[,i], templookup, w, h, tsum$mintemp[i], tsum$maxtemp[i], tsum$meantemp[i], 
              minrangeset=allmintemp, maxrangeset=allmaxtemp, main=des, sub=sub.title)
    cat('\r',paste("Exporting #",i-1, "of", ncol(alldata), "frames", sep=" "))
  }, 
  img.name = paste(des, "_frame_", sep=""),
  imgdir = "img_dir",
  htmlfile = paste(f, ".html",sep=""),  
  autobrowse = FALSE, navigator=FALSE,         
  description = des)                          

f.vid<-paste0(f.root, "_converted.mp4")
saveVideo(
  for(i in 1:ncol(alldata))
  {
    #par(mar = c(3, 3, 1, 0.5), mgp = c(2, 0.5, 0), tcl = -0.3, cex.axis = 0.8, 
    #    cex.lab = 0.8, cex.main = 1)
    ani.options(interval = Interval, nmax=300)
    par(pin=c(6,4.5),cex.sub=1.5, cex.main=1.5)
    plotTherm(alldata[,i], templookup, w, h, tsum$mintemp[i], tsum$maxtemp[i], tsum$meantemp[i], 
              minrangeset=allmintemp, maxrangeset=allmaxtemp, main=des, sub=sub.title)
    cat('\r',paste("Exporting #",i-1, "of", ncol(alldata), "frames", sep=" "))
  }, 
  video.name=f.vid, other.opts = "-vcodec libx264")                          


f.gif<-paste0(f.root, "_converted.gif")
saveGIF(
  for(i in 1:ncol(alldata))
  {
    #par(mar = c(3, 3, 1, 0.5), mgp = c(2, 0.5, 0), tcl = -0.3, cex.axis = 0.8, 
    #    cex.lab = 0.8, cex.main = 1)
    #par(pin=c(6,4.5),cex.sub=1.5, cex.main=1.5)
    plotTherm(alldata[,i], templookup, w, h, tsum$mintemp[i], tsum$maxtemp[i], tsum$meantemp[i], 
              minrangeset=allmintemp, maxrangeset=allmaxtemp, main=des, sub=sub.title)
    cat('\r',paste("Exporting #",i-1, "of", ncol(alldata), "frames", sep=" "))
  }, 
  movie.name=f.gif, interval=Interval)                          



