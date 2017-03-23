Thermimage: Thermal Image Analysis
====



[![cran version](https://www.r-pkg.org/badges/version/Thermimage)](https://www.r-pkg.org/badges/version/Thermimage)
[![downloads](https://cranlogs.r-pkg.org/badges/Thermimage)](https://cranlogs.r-pkg.org/badges/Thermimage)
[![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)
[![Research software impact](http://depsy.org/api/package/cran/Thermimage/badge.svg)](http://depsy.org/package/r/Thermimage)

This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography.

## Recent/release notes

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

[1] 480 640

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

 PlanckR1       PlanckB       PlanckF       PlanckO      PlanckR2 
 2.110677e+04  1.501000e+03  1.000000e+00 -7.340000e+03  1.254526e-02 
```

If you want to check the file data information, type:
```
cbind(unlist(cams$Dates))

                          [,1]                 
FileModificationDateTime "2017-03-22 22:15:09"
FileAccessDateTime       "2017-03-22 23:27:31"
FileInodeChangeDateTime  "2017-03-22 22:15:10"
ModifyDate               "2013-05-09 16:22:23"
CreateDate               "2013-05-09 16:22:23"
DateTimeOriginal         "2013-05-09 22:22:23"
```
or just:
```
cams$Dates$DateTimeOriginal

[1] "2013-05-09 22:22:23"
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
 int [1:480, 1:640] 18090 18074 18064 18061 18081 18057 18092 18079 18071 18071 ...
```

If stored with a TIFF header, the data load in as a pre-allocated matrix of the same dimensions of the thermal image, but the values are integers values, in this case ~18000.  The data are stored as in binary/raw format at 2^16 bits of resolution = 65535 possible values, starting at 1.  These are not temperature values.  They are, in fact, radiance values or absorbed infrared energy values in arbitrary units.  That is what the calibration constants are for.  The conversion to temperature is a complicated algorithm, incorporating Plank's law and the Stephan Boltzmann relationship, as well as atmospheric absorption, camera IR absorption, emissivity and distance to namea  few.  Each of these raw/binary values can be converted to temperature, using the raw2temp function:

```
temperature<-raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                      PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2)
str(temperature)      

num [1:480, 1:640] 23.7 23.6 23.6 23.6 23.7 ...
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
![FLIR JPG rotate 270](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270.png?raw=true)
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
or
![FLIR JPG rotate 270 glowbow palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270glowbowwpal.png?raw=true)
or
![FLIR JPG rotate 270 midgrey palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FLIRJPGrotate270midgreypal.png?raw=true)
or
![FLIR JPG rotate 270 midgreen palette](https://github.com/gtatters/Thermimage/blob/master/READMEimages/FlirJPGrotate270midgreenpal.png?raw=true)


```

```
Plot initial image of raw binary data
```
fields::image.plot(imgr, useRaster=TRUE, col=ironbowpal)
```




## Export Image or Video



## Heat Transfer Calculation


