Teq<-function(Ts=30, Ta=25, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=0, V=1, 
             L=0.1, type="forced"){

  # from Mahoney and King (1977) The use of the equivalent black-body temperautre in the thermal
  # energetics of small birds.  J Thermal Biol. 2: 115-120
  
  if(type=="forced") k<-0.7*310 # from Walsberg and King 1978
  if(type=="free") k<-310
  
  rr<-airdensity(Ta)*airspecificheat(Ta)/(4*E*StephBoltz()*(Ta+273.15)^3) 
  # rr=apparent radiative resistance
  ra<-k*(L/V)^0.5
  #ra=boundary layer resistance to heat flow, assuming the characteristic dimension, L is in
  # metres and the air velocity (V) is in m/sec
  re<-1/(1/ra + 1/rr)
  
  Rni<-qabs(Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=cloud, SE=SE) - StephBoltz()*E*(Ta+273.15)^4
  # Rni=Net radiation absorbed
  
  Teq <- Ta +  Rni*re/(airdensity(Ta)*airspecificheat(Ta)) 
  Teq
  
  }
