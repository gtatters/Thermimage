#' @export
#' 
qabs<-function(Ta=20, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=100){
  # Units of qrad will be W/m2 (provided the Solar, Ld, and Lu are also W/m2)
  # Sources: Blaxter, 1986, Konzelmann et al 1994
  # Ts = surface temperature estimates from thermal imaging (degrees Celsius)
  # Ta = air temperature (degrees Celsius)
  # Tg = ground temperature (degrees Celsius) - if not measured, assume = air temperature
  # RH = relative humidity (fraction)
  # E = animal surface emissivity (for infrared radiation)
  # rho = animal surface reflectivity (for visible, solar spectrum)
  # cloud = estimated cloud cover as fraction (0 = no cloud, 1 = full cloud)
  # SE = measured Solar radiation in W/m2 (values range from 0 to ~1300 W/m2)
  if(length(SE)==1) SE<-rep(SE, length(Ta))
  if(length(Tg)==0) Tg<-Tground(Ta, SE)
  if(length(Tg)>=1) Tg[which(is.na(Tg))]<-Tground(Ta[which(is.na(Tg))], SE[which(is.na(Tg))])
  #if(is.null(Tg) | is.na(Tg)) Tg<-Tground(Ta, SE)
  # If Tground is not supplied, estimate it from our empirical relationship, but recognise
  # that this has limits and will return Ta if used outside its valid range
  Ld<-Ld(Ta, RH=RH, n=cloud)
  Lu<-Lu(Tg)
  # total solar radiation (note: this is worst case scenario since no profile/angle metrics
  # are taken into account.  Animal could change orientation to/away from solar beam)
  # also, this is the maximum measured solar radiation
  IR<-E*(Lu+Ld)/2  
  # multiply the average of Lu and Ld by E (this is the amount of 
  # longwave radiation from the environment absorbed by the surface)
  qabs<-(1-rho)*SE + IR
  names(qabs)<-NULL
  qabs
}
