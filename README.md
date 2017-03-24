Thermimage: Thermal Image Analysis
====



[![cran version](https://www.r-pkg.org/badges/version/Thermimage)](https://www.r-pkg.org/badges/version/Thermimage)
[![downloads](https://cranlogs.r-pkg.org/badges/Thermimage)](https://cranlogs.r-pkg.org/badges/Thermimage)
[![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)
[![Research software impact](http://depsy.org/api/package/cran/Thermimage/badge.svg)](http://depsy.org/package/r/Thermimage)

This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography.

## Recent/release notes

* Version 3.0.0 is on Github (development version)
* Changes in this release include functions for importing thermal video files and exporting for ImageJ functionality

* Version 2.2.3 is on CRAN (as of October 2016). 
* Changes in this release include readflirjpg and flirsettings functions for processing flir jpg meta tag info.

## Features

* Functions for importing FLIR image and video files into R.
* Functions for converting thermal image data from FLIR based files, incorporating calibration information stored within each radiometric image file.
* Functions for exporting calibrated thermal image data for analysis in open source platforms, such as ImageJ.
* Functions for steady state estimates of heat exchange from surface temperatures estimated by thermal imaging.
* Functions for modelling heat exchange under various convective, short-wave, and long-wave radiative heat flux, useful in thermal ecology studies.

## Installation


### On current R (>= 3.0.0)

* From CRAN (stable releases 1.0.+):

```
install.packages("Thermimage")
```

* Development version from Github:

```
library("devtools"); install_github("gtatters/Thermimage",dependencies=TRUE)
```

## Package Imports

* Imports: tiff, png

* Suggests: ggplot2, fields, reshape

## OS Requirements

* Exiftool is required for certain functions.  Installation instructions can be found here: http://www.sno.phy.queensu.ca/~phil/exiftool/install.html

## Examples

## A typical thermal image

![Galapagos Night Heron](https://github.com/gtatters/Thermimage/blob/master/inst/extdata/IR_2412.jpg?raw=true)

Normally, these thermal images require access to software that only runs on Windows operating system.  This package will allow you to import certain FLIR jpgs and videos and process the images.

## Import FLIR JPG

To load a FLIR JPG, you first must install Exiftool as per instructions above.
Open sample flir jpg included with Thermimage package:

```
library(Thermimage)
f<-paste0(system.file("extdata/IR_2412.jpg", package="Thermimage"))
img<-readflirJPG(f, exiftoolpath="installed")
dim(img)

> [1] 480 640
```


The readflirJPG function has used Exiftool to figure out the resolution and properties of the image file.  Above you can see the dimensions are listed as 480 x 640.  Before plotting or doing any temperature assessments, let's extract the meta-tages from the thermal image file.


# Extract meta-tags from thermal image file

```
cams<-flirsettings(f, exiftoolpath="installed", camvals="")
```

This produes a rather long list of meta-tags.  If you only want to see your camera calibration constants, type:

```
plancks<-flirsettings(f, exiftoolpath="installed", camvals="-*Planck*")
unlist(plancks$Info)

> PlanckR1       PlanckB       PlanckF       PlanckO      PlanckR2 
> 2.110677e+04  1.501000e+03  1.000000e+00 -7.340000e+03  1.254526e-02 
```

If you want to check the file data information, type:
```
cbind(unlist(cams$Dates))

> FileModificationDateTime "2017-03-22 22:15:09"
> FileAccessDateTime       "2017-03-22 23:27:31"
> FileInodeChangeDateTime  "2017-03-22 22:15:10"
> ModifyDate               "2013-05-09 16:22:23"
> CreateDate               "2013-05-09 16:22:23"
> DateTimeOriginal         "2013-05-09 22:22:23"
```

or just:
```
cams$Dates$DateTimeOriginal

> [1] "2013-05-09 22:22:23"
```

The most relevant variables to extract for calculation of temperature values from raw A/D sensor data are listed here.  These can all be extracted from the cams output as above. I have simplified the output below, since dealing with lists can be awkward.

```
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
```

## Convert raw binary to temperature

Now you have the img loaded, look at the values:
```
str(img)

> int [1:480, 1:640] 18090 18074 18064 18061 18081 18057 18092 18079 18071 18071 ...
```

If stored with a TIFF header, the data load in as a pre-allocated matrix of the same dimensions of the thermal image, but the values are integers values, in this case ~18000.  The data are stored as in binary/raw format at 2^16 bits of resolution = 65535 possible values, starting at 1.  These are not temperature values.  They are, in fact, radiance values or absorbed infrared energy values in arbitrary units.  That is what the calibration constants are for.  The conversion to temperature is a complicated algorithm, incorporating Plank's law and the Stephan Boltzmann relationship, as well as atmospheric absorption, camera IR absorption, emissivity and distance to namea  few.  Each of these raw/binary values can be converted to temperature, using the raw2temp function:

```
temperature<-raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                      PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2)
str(temperature)      

> num [1:480, 1:640] 23.7 23.6 23.6 23.6 23.7 ...
```

The raw binary values are now expressed as temperature in degrees Celsius (apologies to Lord Kelvin).  Let's plot the temperature data: 

```
library(fields) # should be loaded imported when installing Thermimage
plotTherm(t(temperature), h, w)
```

![FLIR JPG on import](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FlirJPGdefault.png?raw=true)

The FLIR jpg imports as a matrix, but default plotting parameters leads to it being rotated 270 degrees (counter clockwise) from normal perspective, so you should either rotate the matrix data before plotting, or include the rotate270.matrix transformation in the call to the plotTherm function:

```
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix")
```

![FLIR JPG rotate 270](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FlirJPGrotate270.png?raw=true)

If you prefer a different palette:
```
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=rainbowpal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=glowbowpal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=midgreypal)
plotTherm(temperature, w=w, h=h, minrangeset = 21, maxrangeset = 32, trans="rotate270.matrix", 
          thermal.palette=midgreenpal)
```
![FLIR JPG rotate 270 rainbow palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270rainbowpal.png?raw=true)

![FLIR JPG rotate 270 glowbow palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270glowbowpal.png?raw=true)

![FLIR JPG rotate 270 midgrey palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270midgreypal.png?raw=true)


## Export Image or Video

Finding a way to quantitatively analyse thermal images in R is a challenge due to limited interactions with the graphics environment.  Thermimage has a function that allows you to write the image data to a file format that can be imported into ImageJ.  

First, the image matrix needs to be transposed (t) to swap the row vs. column order in which the data are stored, then the temperatures need to be transformed to a vector, a requirement of the writeBin function.  The function writeFlirBin is a wrapper for writeBin, and uses information on image width, height, frame number and image interval (the latter two are included for thermal video saves) but are kept for simplicity to contruct a filename that incorporates image information required when importing to ImageJ:

```
writeFlirBin(as.vector(t(temperature)), templookup=NULL, w=w, h=h, I="", rootname="FLIRjpg")
```

The raw file can be found here: https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRjpg_W640_H480_F1_I.raw?raw=true


# Import Raw File into ImageJ
The .raw file is simply the pixel data saved in raw format but with real 32-bit precision.  This means that the temperature data (negative or positive values) are encoded in 4 byte chunks.  ImageJ has a plethora of import functions, and the File-->Import-->Raw option provides great flexibility.  Once opening the .raw file in ImageJ, set the width, height, number of images (i.e. frames or stacks), byte storage order (little endian), and hyperstack (if desired):

![ImageJ Import Settings](https://github.com/gtatters/Thermimage/blob/master/READMEimages/ImageJImport.png?raw=true)

The image imports clearly just as it would in a thermal image program.  Each pixel stores the calculated temperatures as provided from the raw2temp function above. 

![Image Imported into ImageJ](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRjpg_W640_H480_F1_I.raw.png?raw=true)


## Importing Thermal Videos

Importing thermal videos (March 2017: still in development) is a little more involved and less automated, but below are steps that have worked for seq and fcf files tested.

Set file info and extract meta-tags as done above:

```
# set filename as v
v<-paste0(system.file("extdata/SampleSEQ.seq", package="Thermimage"))

# Extract camera values using Exiftool (needs to be installed)
camvals<-flirsettings(v)
w<-camvals$Info$RawThermalImageWidth
h<-camvals$Info$RawThermalImageHeight
```

Create a lookup variable to convert the raw binary to actual temperature estimates, use parameters relevant to the experiment.  You could use the values stored in the FLIR meta-tags, but these are not necessarily correct for the conditions of interest.  suppressWarnings() is used because of NaN values returned for binary values that fall outside the range.

```
suppressWarnings(
templookup<-raw2temp(raw=1:65535, E=camvals$Info$Emissivity, OD=camvals$Info$ObjectDistance, RTemp=camvals$Info$ReflectedApparentTemperature, ATemp=camvals$Info$AtmosphericTemperature, IRWTemp=camvals$Info$IRWindowTemperature, IRT=camvals$Info$IRWindowTransmission, RH=camvals$Info$RelativeHumidity, PR1=camvals$Info$PlanckR1,PB=camvals$Info$PlanckB,PF=camvals$Info$PlanckF,PO=camvals$Info$PlanckO,PR2=camvals$Info$PlanckR2)
)
plot(templookup, type="l", xlab="Raw Binary 16 bit Integer Value", ylab="Estimated Temperature (C)")
```

![Binary to Temperature Conversion](https://github.com/gtatters/Thermimage/blob/master/READMEimages/CalibrationCurve.png?raw=true)

The advantage of using the templookup variable is in its index capacity.  For computations involving large files, this is most efficient way to convert the raw binary values rapidly without having to call the raw2temp function repeatedly.  Thus, for a raw binary value of 17172, 18273, and 24932:

```
templookup[c(17172, 18273, 24932)]

> [1] 18.30964 24.77935 57.07821

```


We will use the templookup later on, but first to detect where the image frames can be found in the video file.
Using the width and height information, we use this to find where in the video file these are stored.  This corresponds to reproducible locations in the frame header:

```
fl<-frameLocates(v, w, h)
n.frames<-length(fl$f.start)
n.frames; fl

> [1] 2
> $h.start
> [1]    162 308688
> 
> $f.start
> [1]   1391 309917
```

The relative positions of the header start (h.start) are 162 and 308688, and the frame start (f.start) positions are 1391 and 309917.  The video file is a short, two frame (n.frames) sequence from a thermal video.

Then pass the fl data to two different functions, one to extract the time information from the header, and the other to extract the actual pixel data from the image frame itself.  The lapply function will have to be used (for efficiency), but to wrap the function across all possible detected image frames.  Note: For large files, the parallel function, mclapply, is advised (?getFrames for an example):

```
extract.times<-do.call("c", lapply(fl$h.start, getTimes, vidfile=v))
data.frame(extract.times)

> 1 2012-06-13 15:52:08.698
> 2 2012-06-13 15:52:12.665

Interval<-signif(mean(as.numeric(diff(extract.times))),3)
Interval

> [1] 3.97
```

This particluar sequence was actually captured at 0.03 sec intervals, but the sample file in the package was truncated to only two frames to minimise online size requirements for CRAN.  At present, the getTimes function cannot accurately render the time on the first frame.  On the original 100 frame file, it accurately captures the real time stamps, so the error is appears to be how FLIR saves time stamps (save time vs. modification time vs. original time appear highly variable in .seq and .fcf files).  Precise time capture is not crucial but is helpful for verifying data conversion.

After extracting times, then extract the frame data, with the getFrames function:

```
alldata<-unlist(lapply(fl$f.start, getFrames, vidfile=v, w=w, h=h))
class(alldata); length(alldata)/(w*h)

> [1] "integer"
> [1] 2
```

The raw binary data are stored as an integer vector.  Length(alldata)/(w*h) verifies the total # of frames in the video file is 2.

It is best to convert the temperature data in the following manner, although depending on file size and system limits, you may wish to delay converting to temperature until writing the file.

```
alltemperature<-templookup[alldata]
```

I recommend converting the binary and/or temperature variables to a matrix class, where each column represents a separate image frame, while the individual rows correspond to unique pixel positions.  Pixels are filled into the row values the same way across all frames.  Dataframes and arrays are much slower for processing large files.

```
alldata<-unname(matrix(alldata, nrow=w*h, byrow=FALSE))
alltemperature<-unname(matrix(alltemperature, nrow=w*h, byrow=FALSE))
dim(alltemperature)

> [1] 307200      2

```

Frames extracted from thermal vids are upside down

```
plotTherm(alltemperature[,1], w=w, h=h, trans="mirror.matrix")
plotTherm(alltemperature[,2], w=w, h=h, trans="mirror.matrix")
```





# Heat Transfer Calculation


 Minimum required information (units) ####
 Surface temperatures, Ts (oC - note: all temperature units are in oC)
 Ambient temperatures, Ta (oC)
 Characteristic dimension of the object or animal, L (m)
 Surface Area, A (m^2)
 Shape of object: choose from "sphere", "hcylinder", "vcylinder", "hplate", "vplate"

# Required if working outdoors with solar radiation
 Visible surface reflectance, rho, which could be measured or estimated (0-1)
 Solar radiation (SE=abbrev for solar energy), W/m2

# Can be estimated or provided
 Wind speed, V (m/s) - I tend to model heat exchange under different V (0.1 to 10 m/s)
 Ground Temperature, Tg  (oC) - estimated from air temperature if not provided
 Incoming infrared radiation, Ld (will be estimated from Air Temperature)
 Incoming infrared radiation, Lu (will be estimated from Ground Temperature)

# Ground Temperature Estimation
 For Ground Temp, we derived a relationship based on data in Galapagos that describes
 Tg-Ta ~ Se, (N=516, based on daytime measurements)
 Thus, Tg =  0.0187128*SE + Ta
 Derived from daytime measurements within the ranges:
 Range of Ta: 23.7 to 34 C
 Range of SE: 6.5 to 1506.0 Watts/m2
 Or from published work by Bartlett et al. (2006) in the Tground() function, the
 relationship would be Tg = 0.0121*SE + Ta

# Make your Data frame
 Once you have decided on what variables you have or need to model, create a data
 frame with these values (Ta, Ts, Tg, SE, A, L, Shape, rho), where each row corresponds to
 an individual measurement.  The data frame is not required for calling functions,
 but it will force you to assemble your data before proceeding with calculations.
 Other records such as size, date image captured, time of day, species, sex, etc...
 should also be stored in the data frame.

```
Ta<-rnorm(20, 25, sd=10)
Ts<-Ta+rnorm(20, 5, sd=1)
RH<-rep(0.5, length(Ta))
SE<-rnorm(20, 400, sd=50)
Tg<-Tground(Ta,SE)
A<-rep(0.4,length(Ta))
L<-rep(0.1, length(Ta))
V<-rep(1, length(Ta))
shape<-rep("hcylinder", length(Ta))
c<-forcedparameters(V=V, L=L, Ta=Ta, shape=shape)$c
n<-forcedparameters(V=V, L=L, Ta=Ta, shape=shape)$n
a<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$a
b<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$b
m<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$m
type<-rep("forced", length(Ta))
rho<-rep(0.1, length(Ta))
cloud<-rep(0, length(Ta))

d<-data.frame(Ta, Ts, Tg, SE, RH, rho, cloud, A, V, L, c, n, a, b, m, type, shape)
head(d)
>          Ta        Ts       Tg       SE  RH rho cloud   A V   L     c     n a    b    m   type     shape
> 1 28.322047 34.426894 32.67210 359.5081 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
> 2 19.295451 23.458105 23.72816 366.3394 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
> 3 23.640834 26.932211 28.29766 384.8615 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
> 4  6.971665  8.822035 12.14272 427.3600 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
> 5 32.594745 39.277282 38.40423 480.1226 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
> 6 22.613530 28.058783 27.91851 438.4282 0.5 0.1     0 0.4 1 0.1 0.174 0.618 1 0.58 0.25 forced hcylinder
```

# Basic calculations
 The basic approach to estimating heat loss is based on that outlined in
 Tattersall et al (2009)
 This involves breaking the object into component shapes, deriving the exposed areas
 of those shapes empirically, and calcuating Qtotal for each shape:

```
(Qtotal<-qrad() + qconv())
```

 Notice how the above example yielded an estimate.  This is because there are default
 values in all the functions.  In this case, the estimate is negative, meaning
 a net loss of heat to the environment.  It's units are in W/m2.
 To convert the above measures into total heat flux, the Area of each part is required

```
Area1<-0.2 # units are in m2
Area2<-0.3 # units are in m2
Qtotal1<-qrad()*Area1 + qconv()*Area1
Qtotal2<-qrad()*Area2 + qconv()*Area2
QtotalAll<-Qtotal1 + Qtotal2
```

 This approach is used in animal thermal images, such that all component shapes sum to estimate entire
 body heat exchange: WholeBody = Qtotal1 + Qtotal2 + Qtotal3 ... Qtotaln

#  Qtotal is made up of two components: qrad + qconv
 qrad is the net radiative heat flux (W/m2)
 qconv is the net convective heat flux (W/m2)
 qcond is usually ignored unless large contact areas between substrate.  Additional
 information is required to accurately calculate conductive heat exchange and are not
 provided here.

# What is qabs ####
 Radiation is both absorbed and emitted by animals.  I have broken this down into
 partially separate functions.  qabs() is a function to estimate the area specific
 amount of solar and infrared radiation absorbed by the object from the environment:
 qabs() requires information on the air (ambient) temperature, ground temperature,
 relative humidity, emissivity of the object, reflectivity of the object,
 proportion cloud cover, and solar energy.
 
```
qabs(Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 400)
```

compare to a shaded environment with lower SE:

```
qabs(Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 100)
```
# What is qrad 
 Since the animal also emits radiation, qrad() provides the net radiative heat
 transfer.
```
qrad(Ts = 27, Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 100)
```
 Notice how the absorbed environmental radiation is ~440 W/m2, but the animal is also losing
 losing a similar amount, so once we account for the net radiative flux, it very nearly
 balances out at a slightly negative number (-1.486 W/m2)

# Ground temperature ####
If you have measured ground temperature, then simply include it in the call to qrad:

```
qrad(Ts = 30, Ta = 25, Tg = 28, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 100)
```

 If you do not have ground temperature, but have measured Ta and SE, then let
 Tg=NULL.  This will force a call to the Tground() function to estimate Tground
 It is likely better to assume that Tground is slightly higher than Ta, at least
 in the daytime.  If using measurements obtained at night (SE=0), then you will have
 to provide both Ta and Tground, since Tground could be colder equal to Ta depending
 on cloud cover.

# What is hconv
 This is simply the convective heat coefficient.  This is used in calculating the
 convective heat transfer and/or operative temperature but usually you will not need
 to call hconv() yourself

# What is qconv
 This is the function to calculate area specific convective heat transfer, analagous
 to qrad, except for convective heat transfer.  Positive values mean heat is gained
 by convection, negative values mean heat is lost by convection.  Included in the
 function is the ability to estimate free convection (which occurs at 0 wind speed)
 or forced convection (wind speed >=0.1 m/s).  Unless working in a completely still
 environment, it is more appropriate to used "forced" convection down to 0.1 m/s
 wind speed.  Typical wind speeds indoors are likely <0.5 m/s, but outside can
 vary wildly.
 In addition to needing surface temperature, air temperature, and velocity, you
 need information/estimates on shape.  L is the critical dimension of the shape,
 which is usually the height of an object within the air stream.  The diameter of
 a horizontal cylinder is its critical dimension.  Finally, shape needs to be
 assigned.  see help(qconv) for details.

```
qconv(Ts = 30, Ta = 20, V = 1, L = 0.1, type = "forced", shape="hcylinder")
qconv(Ts = 30, Ta = 20, V = 1, L = 0.1, type = "forced", shape="hplate")
qconv(Ts = 30, Ta = 20, V = 1, L = 0.1, type = "forced", shape="sphere")
```
 notice how the horizontal cylinder loses less than the horizontal plate which loses
 less than the sphere.  Spherical objects lose ~1.8 times as much heat per area as
 cylinders.


#  Which is higher: convection or radiation? ####
 Take a convection estimate at low wind speed:

```
qconv(Ts = 30, Ta = 20, V = 0.1, L = 0.1, type = "forced", shape="hcylinder")
```

compare to a radiative estimate (without any solar absorption):

```
qrad(Ts = 30, Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 0)
```

 in this case, the net radiative heat loss is greater than convective heat loss
 if you decrease the critical dimension, however, the convective heat loss per m2
 is much greater.  This is effectively how convective exchange works: small objects
 lose heat from convection more readily than large objects (e.g. frostbite on fingers)
 If L is 10 times smaller:
```
qconv(Ts = 30, Ta = 20, V = 0.1, L = 0.01, type = "forced", shape="hcylinder")
qrad(Ts = 30, Ta = 20, Tg = NULL, RH = 0.5, E = 0.96, rho = 0.1, cloud = 0, SE = 0)
```
 convection and radiative heat transfer are nearly the same.
 A safe conclusion here is that larger animals would rely more on radiative heat transfer
 than they would on convective heat transfer


# Sample Calculations ####
 Ideally, you have all parameters estimated or measured and put into a data frame.
 Using the dataframe, d we constructed earlier
```
(qrad.A<-with(d, qrad(Ts, Ta, Tg, RH, E=0.96, rho, cloud, SE)))
(qconv.free.A<-with(d, qconv(Ts, Ta, V, L, c, n, a, b, m, type="free", shape)))
(qconv.forced.A<-with(d, qconv(Ts, Ta, V, L,  c, n, a, b, m, type, shape)))

qtotal<-A*(qrad.A + qconv.forced.A)

d<-data.frame(d, qrad=qrad.A*A, qconv=qconv.forced.A*A, qtotal=qtotal)
head(d)
```
 Test the equations out for consistency ####
 Toucan Proximal Bill at 10oC (from Tattersall et al 2009 spreadsheets)
```
A<-0.0097169
L<-0.0587
Ta<-10
Tg<-Ta
Ts<-15.59
SE<-0
rho<-0.1
E<-0.96
RH<-0.5
cloud<-1
V<-5
type="forced"
shape="hcylinder"
(qrad.A<-qrad(Ts=Ts, Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=cloud, SE=SE))
```
 compare to calculated value of -28.7 W/m2
 the R calculations differ slightly from Tattersall et al (2009) since they did not use
 estimates of longwave radiation (Ld and Lu), but instead assumed a simpler, constant Ta
 environment.
```
(qrad.A<-qrad(Ts=Ts, Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=0, SE=SE))
```
 but if cloud = 0, then the qrad values calculated here are much higher than calculated by
 Tattersall et al (2009) since they only estimated under simplifying, indoor conditions
 where background temperature = air temperature.  In the outdoors, then, cloud presence
 would affect estimates of radiative heat loss
(qconv.forced.A<-qconv(Ts, Ta, V, L, type=type, shape=shape))

compare to calculated value of -191.67 W/m2 - which is really close!  The difference lies
in estimates of air kinematic viscosity used

(qtotal.A<-(qrad.A + qconv.forced.A))

Total area specific heat loss for the proximal area of the bill (Watts/m2)
qtotal.A*A

 Total heat loss for the proximal area of the bill (Watts)
 This lines up well with the published values in Tattersall et al (2009).
 This was confirmed in van de Van (2016) where they recalculated the area specifi
 heat flux from toucan bills to be ~65 W/m2:
qrad(Ts=Ts, Ta=Ta, Tg=Tg, RH=0.5, E=0.96, rho=rho, cloud=1, SE=0) + 
  qconv(Ts, Ta, V, L, type="free", shape=shape)


# Estimating Operative Temperature ####
 Operative environmental temperature is the expression of the "effective temperature" an
 object is experiencing, accounting for heat absorbed from radiation and heat lost to convection
 In other words, it is often used by some when trying to predict
 animal body temperature as a null expectation or reference point to determine whether
 active thermoregulation is being used.  More often used in ectotherm studies, but as an
 initial estimate of what a freely moving animal temperature would be, it serves a useful
 reference.  Usually, people would measure operative temperature with a model of an object
 placed into the environment, allowing wind, solar radiation and ambient temperature to
 influence its temperature.  There are numerous formulations for it.  The one here is from
 in Angilletta's book on Thermal Adaptations.  Note: in the absence of sun or wind,
 operative temperature is simply ambient temperature.

# Operative temperature with varying reflectances:
```
Ts<-40
Ta<-30
SE<-seq(0,1100,100)
Toperative<-NULL
for(rho in seq(0, 1, 0.1)){
  temp<-Te(Ts=Ts, Ta=Ta, Tg=NULL, RH=0.5, E=0.96, rho=rho, cloud=1, SE=SE, V=1, 
           L=0.1, type="forced", shape="hcylinder")
  Toperative<-cbind(Toperative, temp)
}
rho<-seq(0, 1, 0.1)
Toperative<-data.frame(SE=seq(0,1100,100), Toperative)
colnames(Toperative)<-c("SE", seq(0,1,0.1))
matplot(Toperative$SE, Toperative[,-1], ylim=c(25, 50), type="l", xlim=c(0,1000),
        main="Effects of Altering Reflectance from 0 to 1",
        ylab="Operative Temperature (°C)", xlab="Solar Radiation (W/m2)", lty=1,
        col=flirpal[rev(seq(1,380,35))])
for(i in 2:12){
    ymax<-par()$yaxp[2]
    xmax<-par()$xaxp[2]  
    x<-Toperative[,1]; y<-Toperative[,i]
    lm1<-lm(y~x)
    b<-coefficients(lm1)[1]; m<-coefficients(lm1)[2]
    if(max(y)>ymax) {xpos<-(ymax-b)/m; ypos<-ymax}
    if(max(y)<ymax) {xpos<-xmax; ypos<-y[which(x==1000)]}
    text(xpos, ypos, labels=rho[(i-1)])
}
```
