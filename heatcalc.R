# What is needed to start estimating heat loss

# Definitely required ####
# Surface temperatures, Ts (oC)
# Ambient temperatures, Ta (oC)
# Characteristic dimension, L (m)
# Area, A (m^2)

# Required if working outdoors with solar radiation ####
# Surface visual reflectance, rho, which could be measured or estimated
# Solar radiation, W/m2

# Can be estimated or provided ####
# Wind speed, V (m/s)
# Ground Temperature, Tg  (oC) - estimated from air temperature if not provided
# Incoming infrared radiation, Ld (will be estimated from Air Temperature)
# Incoming infrared radiation, Lu (will be estimated from Ground Temperature)

library(Thermimage)

Lw <- function(AT=293, RH=0.5, n=0){
  # Units: W/m2
  # derived from Gabathuler et al 2001 Physical Geography 22: 99-114
  # from a high altitude site
  # Terms used are similar to the Ld function, but Gabathuler refers to them differently
  # n (i.e. Ko) is a clearness index (1 = full cloud, 0 = clear sky)
  # RH.pct (i.e. RH*100) is relative humidity in percent
  # AT is air temperature in Kelvin
  RH.pct<-RH*100
  Ko<-n
  Lw<-StephBoltz()*(-21*Ko + AT)^4 + 0.84*RH.pct - 57
  Lw
}
  
Ld<-function(AT=293, RH=0.5, n=0.5){
  # Units: W/m2
  # Derived from Konzelmann et al 1994
  # Based on estimating the actual sky emissivity, since if you know the air temperature
  # you can estimate incoming infrared radiation using the standard e*theta*T^4 relationship
  
  # RH = relative humidity (fraction)
  # n=fractional cloud cover (0=clear, 1=cloud)
  # ecs=emissivity clear sky
  # WVP=water vapour pressure (kPa)
  # AT=air temperature (Kelvin)
  
  WVPs<-0.611*exp(17.27*(AT-273.15)/(AT-36)) 
  # saturated vapour pressure at AT 
  WVP<-RH*WVPs
  ecs<-0.23 + 0.433*(WVP/AT)^(1/8)
  ecl<-0.976 # emissivity of cloud 
  etotal<-ecs*(1-n^2) + ecl*n^2
  Ld<-etotal*StephBoltz()*AT^4
  Ld
}

qrad<-function(Ts=30, Ta=20, Tg=Ta, RH=0.5, E=0.96, rho=0.1, cloud=0, Solar=0){
  # Units of qrad will be W/m2 (provided the Solar, Ld, and Lu are also W/m2)
  # Sources: Blaxter, 1986, Konzelmann et al 1994
  # Ts = surface temperature estimates from thermal imaging (degrees Celsius)
  # Ta = air temperature (degrees Celsius)
  # Tg = ground temperature (degrees Celsius) - if not measured, assume = air temperature
  # RH = relative humidity (fraction)
  # E = animal surface emissivity (for infrared radiation)
  # rho = animal surface reflectivity (for visible, solar spectrum)
  # cloud = estimated cloud cover as fraction (0 = no cloud, 1 = full cloud)
  # Solar = measured Solar radiation in W/m2 (values range from 0 to ~1300 W/m2)
  
  # Terrain emissivities vary from 0.89 (sand, snow) to 0.97 (moist soil) - Blaxter, 1986
  Eground<-0.97
  Ld<-Ld(Ta+273.15, RH=RH, n=cloud)
  Lu<-Eground*StephBoltz()*(Tg+273.15)^4
  qradsolar<-Solar
  # total solar radiation (note: this is worst case scenario since no profile/angle metrics
  # are taken into account.  Animal could change orientation to/away from solar beam)
  # also, this is the maximum measured solar radiation
  qradIR<-E*(Lu+Ld)/2  
  # multiply the average of Lu and Ld by E (this is the amount of 
  # longwave radiation from the environment absorbed by the surface)
  qradsurf<-E*StephBoltz()*(Ts+273.15)^4
  # amount of radiation emitted by the surface
  Rnet<-(1-rho)*qradsolar + qradIR - qradsurf
  Rnet # positive values = heat gain, negative values = heat loss
}

qconv<-function(Ts=30, Ta=20, V=1, L=1, a=0.24, n=0.6, b=0.58, m=0.25, type="forced"){
  # Units of qconv will be W/m2
  # Sources: Blaxter, 1986
  # Ts = surface temperature estimates from thermal imaging (degrees Celsius)
  # Ta = air temperature (degrees Celsius)
  # V = air velocity (m/s)
  # L = characteristic dimension (metres), sometimes referred to as d
  # a = coefficient used in forced convection 
  # n = coefficient used in forced convection 
  # b = coefficient used in free convection (0.58 upright cylinder, 0.48 flat cylinder)
  # m = coefficient used in free convection (0.25 laminar flow)
  # type = forced or free convection
  
  if(type=="forced" | type=="Forced") Nu<-Nusseltforced(a=a, n=n, V=V, L=L, Ta=Ta)
  if(type=="free" | type=="Free") Nu<-Nusseltfree(b=b, m=m, L=L, Ts=Ts, Ta=Ta)
  
  k<-airtconductivity(Ta)
  # hc = convective heat coefficient, depends on the Nu, k and L
  hc<-Nu*k/L
  qconv<-hc*(Ta-Ts)
  qconv # positive values = heat gain, negative values = heat loss
}


qcond<-function(Ts=30, Tc=20, ktiss=0.502, x=1){
  # Units: W/m2
  # Ts = surface temperature (degrees Celsius) of surface in contact
  # Tc = contact temperature (degrees Celsius) - usually ground temperature
  # ktiss = thermal conductivity of tissue (W/m/oC) 
  # x = thickness of slab conducting heat (m)
  # for a sphere, the true x = rx*(r+x), where r=radius
  # for a cylinder, it is ln(1+x/r)
  # Based on skin conductivity (0.502 Wm-1oC-1) from Gates, 1980
  # Gates, D.M. 1980 Biophysical Ecology. Berlin: Springer – Verlag. 
  qcond<-ktiss*(Tc-Ts)/x
  qcond 
  # to make sense of this value, divide by the true distance of heat transfer and 
  # multiply by the exposed area to calculate actual heat transfer by conduction
}

  
