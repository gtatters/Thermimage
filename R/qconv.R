#' @export
#' 
qconv<-function(Ts=30, Ta=20, V=1, L=0.1, c=NULL, n=NULL, a=NULL, b=NULL, m=NULL, type="forced",
                shape="hcylinder"){
  # Units of qconv will be W/m2/oC
  # Sources: Blaxter, 1986
  # Ts = surface temperature estimates from thermal imaging (degrees Celsius)
  # Ta = air temperature (degrees Celsius)
  # V = air velocity (m/s)
  # L = characteristic dimension (metres), sometimes referred to as d
  # c = coefficient used in forced convection 
  # n = coefficient used in forced convection 
  # a = coefficient used in free convection (usually 1)
  # b = coefficient used in free convection (0.58 upright cylinder, 0.48 flat cylinder)
  # m = coefficient used in free convection (0.25 laminar flow)
  # type = forced or free convection
  qconv<-(Ta-Ts)*hconv(Ts=Ts, Ta=Ta, V=V, L=L, c=c, n=n, a=a, b=b, m=m, type=type, shape=shape)
  names(qconv)<-NULL
  qconv # positive values = heat gain, negative values = heat loss
}
