# Stored in package folder
# commands for package maintenance that cannot be saved in the R folder without causing 
# issues when building the package for uploading to CRAN

# Create a pdf manual of the package ####
pack<-"Thermimage"
path<-find.package(pack)
system(paste(shQuote(file.path(R.home("bin"), "R")),
             "CMD", "Rd2pdf", shQuote(path)))


# Running the following might work better than the Rstudio "check" command:
library(devtools)
devtools::build() #%>% 
  install.packages(repos = NULL, type = "source")

# Create documentation for new function
# First add the function to working environment
# then type prompt(functionname)
# Rstudio will create an Rd file in the root directory you can edit

  
# version history
# v1. initial package with the binary to temperature conversion equations and palettes 
  # for working with thermal image presentation
# v2. added thermal modelling equations to convert surface temperatures into estimates of 
  # heat flux across surfaces to the environment
# v2.1. added operative temperature (Te)
# v2.1.1 added equivalent temperature (Teq)
# v2.2.0 added readflirjpg and flirsettings functions
# v3.0.0 added functions to process .seq and .fcf files
