# Thermimage: Thermal Image Analysis
====
# This is a collection of functions for assisting in converting extracted raw data from infrared thermal images and converting them to estimate temperatures using standard equations in thermography

[![cran version](https://www.r-pkg.org/badges/version/Thermimage)](https://www.r-pkg.org/badges/version/Thermimage)
[![downloads](https://cranlogs.r-pkg.org/badges/Thermimage)](https://cranlogs.r-pkg.org/badges/Thermimage)
[![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)](https://cranlogs.r-pkg.org/badges/grand-total/Thermimage)
[![Research software impact](http://depsy.org/api/package/cran/Thermimage/badge.svg)](http://depsy.org/package/r/Thermimage)


## Recent/release notes

* Version 2.2.3 is on CRAN (as of April 2016). Changes in this release include readflirjpg and flirsettings functions for processing flir jpg meta tag info.

## Features

* 
* 

## Installation

### On current R (>= 3.0.0)

* From CRAN (stable release 1.0.+)
* Development version from Github:
  ```
library("devtools"); install_github("lme4/lme4",dependencies=TRUE)
```
(This requires `devtools` >= 1.6.1, and installs the "master" (development) branch.)
This approach builds the package from source, i.e. `make` and compilers must be installed on your system -- see the R FAQ for your operating system; you may also need to install dependencies manually. Specify `build_vignettes=FALSE` if you have trouble because your system is missing some of the `LaTeX/texi2dvi` tools.
* Usually up-to-date development binaries from `lme4` r-forge repository:
  ```
install.packages("lme4",
                 repos=c("http://lme4.r-forge.r-project.org/repos",
                         getOption("repos")[["CRAN"]]))
```
(these source and binary versions are updated manually, so may be out of date; if you believe they are, please contact the maintainers).
