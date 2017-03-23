#' @export
#' 
Te<-function(Ts=30, Ta=25, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=0, V=1, 
             L=0.1, c=NULL, n=NULL, a=NULL, b=NULL, m=NULL, type="forced", shape="hcylinder"){
  
  Te <- Ta + (qabs(Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=cloud, SE=SE) - StephBoltz()*E*(Ta+273.15)^4) / 
    (hconv(Ts=Ts, Ta=Ta, V=V, L=L, c = NULL, n = NULL, a = NULL, b = NULL, m = NULL,  type=type, shape=shape) + 4*StephBoltz()*E*(Ta+273.15)^3)  
  Te
  
  }
