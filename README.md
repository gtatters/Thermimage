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

![myimage-alt-tag](https://github.com/gtatters/Thermimage/blob/master/inst/extdata/IR_2412.jpg?raw=true)

How to process or 

## Example using the flirsettings and readflirjpg functions

Open sample flir jpg included with Thermimage package:

```
imagefile<-paste0(system.file("extdata/IR_2412.jpg", package="Thermimage"))
```

Extract meta-tags from thermal image file

```
cams<-flirsettings(imagefile, exiftool="installed", camvals="")
cams
```

Set variables for calculation of temperature values from raw A/D sensor data

```
Emissivity<-cams$Info$Emissivity                      # Image Saved Emissivity - should be ~0.95 or 0.96
ObjectEmissivity<-0.96                                # Object Emissivity - should be ~0.95 or 0.96
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

Import image from flir jpg to obtain binary data:

```
img<-readflirJPG(imagefile, exiftool="package")
```

Rotate image before plotting
```
imgr<-rotate270.matrix(img)
```

Plot initial image of raw binary data
```
fields::image.plot(imgr, useRaster=TRUE, col=ironbowpal)
```

## Convert raw binary to temperature


## Export Image or Video



## Heat Transfer Calculation


