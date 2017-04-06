#' @export
#' 
Ld<-function(Ta=20, RH=0.5, n=0.5){
  # Longwave radiation downward to surface.  Units: W/m2
  # Derived from Konzelmann et al 1994.  PARAMETERIZATION OF GLOBAL AND LONGWAVE INCOMING RADIATION FOR THE GREENLAND ICE-SHEET.  
  # Global and Planetary Change.  9: 143-164
  # Based on estimating the actual sky emissivity, since if you know the air temperature
  # you can estimate incoming infrared radiation using the standard e*theta*T^4 relationship
  # RH = relative humidity (fraction from 0 to 1)
  # n=fractional cloud cover (0=clear, 1=cloud)
  # ecs=emissivity clear sky
  # WVP=water vapour pressure (kPa)
  # AT=air temperature (Kelvin)
  AT <- Ta + 273.15
  WVPs<-611*exp(17.27*(AT-273.15)/(AT-36))  # Pascals
  # saturated vapour pressure at AT 
  WVP<-RH*WVPs
  ecs<-0.23 + 0.443*(WVP/AT)^(1/8) # emissivity clear sky
  ecl<-0.976 # emissivity of cloud 
  etotal<-ecs*(1-n^2) + ecl*n^2
  Ld<-etotal*StephBoltz()*AT^4
  Ld
}
