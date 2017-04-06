#' @export
#' 
Grashof<-function(L=1, Ts=25, Ta=20){
  # Grashof number
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man.
  # Gr=agL^3(Ts-Ta)/v^2
  # L is the characteristic dimension, usually the vertical dimension.  For reference, 
  # a cylinder's characteristic L would be its height, assuming it is standing on its end
  # Units of L should be in metres
  # This L should be the same L as is used for the convective coefficient calculation
  # Ts is the surface temperature
  # Ta is the ambient temperature
  # v2 is the kinematic viscosity squared
  a<-1/273                     # (coefficient of thermal expansion of air)
  g<- 9.81                     # acceleration due to gravity (Units: m/s2)
  v<- airviscosity(Ta)
  Gr<-a*g*L^3*(Ts-Ta)/v^2
  Gr
  }
