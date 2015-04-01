\name{raw2temp}
\alias{raw2temp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Converts raw thermal data into temperature (oC)
}
\description{
Converts a raw value obtained from binary thermal image video file into estimated
temperature using standard equations used in infrared thermography.
}
\usage{
raw2temp(raw, E = 1, OD = 1, RTemp = 20, ATemp = RTemp, IRWTemp = RTemp, IRT = 1,
RH = 50, PR1 = 21106.77, PB = 1501, PF = 1, PO = -7340, PR2 = 0.012545258)
}  
\arguments{
  \item{raw}{
A/D bit signal from FLIR file. FLIR .seq files and .fcf files store data in a 16-bit encoded value. This means it can range from 0 up to 65535.  This is referred to as the raw value.  The raw value is actually what the sensor detects which is related to the radiance hitting the sensor. At the factory, each sensor has been calibrated against a blackbody radiation source so calibration values to conver the raw signal into the expected temperature of a blackbody radiator are provided. Since the sensors do not pick up all wavelengths of light, the calibration can be estimated usinga limited version of Planck's law.  But the blackbody calibration is still critical to this.
}
  \item{E}{
Emissivity - default 1, should be ~0.95 to 0.97 depending on object of interest.  Determined by user.
}
  \item{OD}{
Object distance from thermal camera in metres
}
  \item{RTemp}{
Apparent reflected temperature (oC) of the enrivonment impinging on the object of interest - one value from FLIR file (oC), default 20C.
}
  \item{ATemp}{
Atmospheric temperature (oC) for infrared tranmission loss - one value from FLIR file (oC) - default value is set to be equal to the reflected temperature.  Transmission loss is a function of absolute humidity in the air.
}
  \item{IRWTemp}{
Infrared Window Temperature (oC). Default is set to be equivalent to reflected temp (oC).  
}
  \item{IRT}{
Infrared Window transmission - default is set to 1.0.  Likely ~0.95-0.97. Should be empirically determined.  Germanium windows with anti-reflective coating typically have IRTs ~0.95-0.97.
}
  \item{RH}{
Relative humidity expressed as percent.  Default value is 50.
}
  \item{PR1}{
PlanckR1 - a calibration constant for FLIR cameras
}
  \item{PB}{
PlanckB - a calibration constant for FLIR cameras
}
  \item{PF}{
PlanckF - a calibration constant for FLIR cameras
}
  \item{PO}{
PlanckO - a calibration constant for FLIR cameras
}
  \item{PR2}{
PlanckR2 - a calibration constant for FLIR cameras
}
}
\details{
Note: PR1, PR2, PB, PF, and PO are specific to each camera and result from the calibration 
at factory of the camera's Raw data signal recording from a blackbody radiation source.  
Sample calibration constants for three different cameras (FLIR SC660 with 24x18 degree lens,
FLIR T300 with 25x19 degree lens, FLIR T300 with 2xtelephoto.

Calibration Constants by cameras:  SC660, T300(25o), T300(25o with telephoto)
\tabular{lccc}{
Constant \tab FLIR SC660 \tab FLIR T300 \tab FLIR T300(t)\cr
PR1: \tab 21106.77 \tab 14364.633 \tab 14906.216\cr
PB: \tab 1501 \tab 1385.4 \tab 1396.5\cr
PF: \tab 1 \tab 1 \tab 1\cr
PO: \tab -7340 \tab -5753 \tab -7261\cr
PR2: \tab  0.012545258 \tab 0.010603162 \tab 0.010956882\cr
}

PR1: PlanckR1 calibration constant
PB: PlanckB calibration constant  
PF: PlanckF calibration constant   
PO: PlanckO calibration constant
PR2: PlanckR2 calibration constant

The calibration constants allow for the raw digital signal conversion to and from the 
predicted radiance of a blackbody, using the standard equation: 

temperature<-PB/log(PR1/(PR2*(raw+PO))+PF)-273.15

Also used in calculations for transmission loss are the following constants:

ATA1: Atmospheric Trans Alpha 1  0.006569 

ATA2: Atmospheric Trans Alpha 2  0.012620

ATB1: Atmospheric Trans Beta 1  -0.002276

ATB2: Atmospheric Trans Beta 2  -0.006670

ATX:  Atmospheric Trans X        1.900000
}
\value{
Returns numeric value in oC.  Can handle vector or matrix objects
}
\references{
1. http://130.15.24.88/exiftool/forum/index.php/topic,4898.60.html

2. Minkina, W. and Dudzik, S. 2009. Infrared Thermography: Errors and Uncertainties.  
Wiley Press, 192 pp.
}
\author{
Glenn J. Tattersall
}
\section{Warning }{Raw values need to be greater than Planck0 constant}

\seealso{
\code{\link{temp2raw}},
}
\examples{
# General Usage:
# raw2temp(raw,E,OD,RTemp,ATemp,IRWTemp,IRT,RH,PR1,PB,PF,PO,PR2)
###
# Example with all settings at default/blackbody levels:
raw2temp(18109,1,0,20,20,20,1,50,PR1=21106.77,PB=1501,PF=1,PO=-7340,PR2=0.012545258)

# Example with emissivity=0.95, distance=1m, window transmission=0.96, all temperatures=20C, 
# 50 RH:

raw2temp(18109,0.95,1,20,20,20,0.96,50) 
# Note: default calibration constants for the FLIR camera will be used if you leave out the
# calibration data

# Vector example
r<-17000:25000
t1.0<-raw2temp(r,1,0,20,20,20,0.96,50)
t0.9<-raw2temp(r,0.9,0,20,20,20,0.96,50)

dev.off()
plot(r,t1.0,type="l",col="red")
lines(r,t0.9,col="black")
legend("topleft", bty = "n", c("E=1.0", "E=0.9"), lty=c(1,1), col=c("red", "black"))

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{thermal imaging}
\keyword{digital video}% __ONLY ONE__ keyword per line
