# Stored in package folder
# commands for package maintenance that cannot be saved in the R folder without causing 
# issues when building the package for uploading to CRAN

# Create a pdf manual of the package ####
pack<-"Thermimage"
path<-find.package(pack)
system(paste(shQuote(file.path(R.home("bin"), "R")),
             "CMD", "Rd2pdf", shQuote(path)))

