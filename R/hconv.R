#' @export
#' 
hconv<-function(Ts=30, Ta=20, V=1, L=0.1, c=NULL, n=NULL, a=NULL, b=NULL, m=NULL, type="forced", 
                shape="hcylinder"){
  # Units of qconv will be W/m2/oC
  # Sources: Blaxter, 1986
  # Ta = air temperature (degrees Celsius)
  # V = air velocity (m/s)
  # L = characteristic dimension (metres), sometimes referred to as d (usually the vertical
  # displacement of the object of interest)
  # c = coefficient used in forced convection 
  # n = coefficient used in forced convection 
  # a = coefficient used in free convection
  # b = coefficient used in free convection (0.58 upright cylinder, 0.48 flat cylinder)
  # m = coefficient used in free convection (0.25 laminar flow)
  # type = forced or free convection
  # shape = shape of the object losing heat.  choose from "plate", "sphere", "cylinder"
  V[V==0]<-0.000001
  Gr<-Grashof(L,Ts, Ta)
  Re<-Reynolds(V, L, airviscosity(Ta))
  BuoyInert<-Gr/Re^2
  # ratio of buoyant to inertial forces (used to double check whether to use free or 
  # forced)
  # Nu<-rep(NA, length(type))
  Nu<-c()
  Nuforced<-Nusseltforced(c=c, n=n, V=V, L=L, Ta=Ta, shape=shape)
  Nufree<-Nusseltfree(a=a, b=b, m=m, L=L, Ts=Ts, Ta=Ta, shape=shape)
  
  if(any(V==0)) type[V==0]<-"free"
  
  Nu[type=="forced" | type=="Forced" | BuoyInert<=0.1]<-Nuforced[type=="forced" |
              type=="Forced" | BuoyInert<=0.1]
  
  # Nu[type=="free" | type=="Free" | BuoyInert>=16 | V<0.1]<-Nufree[type=="free" |
  #             type=="Free" | BuoyInert>=16 | V<0.1]
  
  Nu[type=="free" | type=="Free"]<-Nufree[type=="free" | type=="Free"]
  
  #Nu[which(BuoyInert > 0.1 & BuoyInert < 16)]<-max(Nuforced, Nufree)
  #if(type=="forced" | type=="Forced" | BuoyInert<=0.1) Nu<-Nuforced
  #if(type=="free" | type=="Free" | BuoyInert>=16) Nu<-Nufree
  #if(BuoyInert > 0.1 & BuoyInert < 16) Nu<-max(Nuforced, Nufree)
  
  k<-airtconductivity(Ta)
  hconv<-Nu*k/L
  names(hconv)<-NULL
  hconv 
}
