qrad<-function(Ts=30, Ta=25, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=0){
  # Net radiation absorbed and emitted by the object
  # calls the qabs() function and subtracts the emitted radiation based on surface temperature
  # measurements
  # Positive values = heat gain, negative values = heat loss
  qrad<-qabs(Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=cloud, SE=SE)-E*StephBoltz()*(Ts+273.15)^4
  names(qrad)<-NULL
  qrad
}
