#' @export
#' 
flirsettings<-function(imagefile, exiftoolpath="installed", camvals=NULL)
{
  # source: http://timelyportfolio.github.io/rCharts_catcorrjs/exif/
  # see also here for converting thermal image values
  # http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=4898.45
  # accessing exiftool from system command line
  # Decipher Camera Meta Data information 
  # Need to have exiftool installed in your OS's system folder or equivalent
  # http://www.sno.phy.queensu.ca/~phil/exiftool/
  
  if(!exiftoolpath=="installed"){
    exiftoolcheck<-paste0(exiftoolpath, "/exiftool")
    
    if(!file.exists(exiftoolcheck)) {
      stop("Exiftool not installed at this location.  Please check path usage.")
    }
    
  }
  
  if(exiftoolpath=="installed"){
    exiftoolpath<-""
  }  
 

  if(is.null(camvals)) {
    camvals<-"-flir -*Emissivity -*Original -*Date -*Planck* -*Distance -*Temperature* -*Transmission -*Humidity -*Height -*Width -*Model* -*Median -*Range -*Raw*"
  }
  
  syscommand<-paste0(exiftoolpath, "exiftool")
  info<-system2(syscommand, args=paste0(shQuote(imagefile), " ", camvals), stdout=T)
  info.df<-utils::read.fwf(textConnection(info), widths=c(32,1,1,60), stringsAsFactors=FALSE, header=FALSE, fill=FALSE)
  info.df<-info.df[,-c(2,3)]
  
  whichdates<-grep("Date", info.df[,1]) 
  # these variables are date/time variables
  datevariables<-gsub(" ", "", info.df[whichdates,1])
  datevariables<-gsub("/", "", datevariables)
  datevalues<-as.character(gsub("[^0-9: .-]","", info.df[whichdates,2]))
    
  notdates<-!1:nrow(info.df) %in% grep("Date", info.df[,1])
  variables<-gsub(" ", "", info.df[notdates,1])
  variables<-gsub("/", "", variables)
  values<-as.character(gsub("[^0-9: .-]","", info.df[notdates,2]))
  values[which(info.df[notdates,2]=="TIFF")]<-"TIFF"
  values[which(info.df[notdates,2]=="PNG")]<-"PNG"
  values<-gsub("[[:space:]]", "", values) 
  # removes all spaces from non-date values
  suffixes<-gsub("([0-9.])","",info.df[notdates,2])
  
  dates<-gsub(":", "-", substr(datevalues, 1, 10), fixed=TRUE)
  times<-substr(datevalues, 12, 19)
  tz<-substr(datevalues, nchar(datevalues)-4,nchar(datevalues))
  no.tz<-grep("[:]", substr(tz,1,1))
  # which timezones were blank
  tz<-gsub(":", "", tz, fixed=TRUE)
  # remove colons from tz
  tz[no.tz]<-"+0000"
  # when in doubt, force the times without TZ to "+00:00".  not sure how to fix this
  tz<-paste0(" +", tz)
  datechar<-paste0(dates, " ", times, tz)
  datevalues<-strptime(datechar, format="%Y-%m-%d %H:%M:%S%z")

  df<-as.list(values)
  names(df)<-variables
  
  suppressWarnings(
    df[!is.na(as.numeric(values))]<-as.numeric(df[!is.na(as.numeric(values))])
  )
  
  df2<-data.frame(datevalues)
  df2<-as.list(t(df2))
  names(df2)<-datevariables
  
  settings<-list(df, df2)
  names(settings)<-c("Info", "Dates")
  
  rm(exiftoolpath)
  return(settings)
}
