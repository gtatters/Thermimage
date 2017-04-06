#' @export
#' 
qcond<-function(Ts=30, Tc=20, ktiss=0.502, x=1){
  # Units: W/m2
  # Ts = surface temperature (degrees Celsius) of surface in contact
  # Tc = contact temperature (degrees Celsius) - usually ground temperature
  # ktiss = thermal conductivity of tissue (W/m/oC) 
  # x = thickness of slab conducting heat (m)
  # for a sphere, the true x = rx*(r+x), where r=radius
  # for a cylinder, it is ln(1+x/r)
  # Based on skin conductivity (0.502 Wm-1oC-1) from Gates (1980) Biophysical Ecology
  qcond<-ktiss*(Tc-Ts)/x
  qcond 
  # to make sense of this value, divide by the true distance of heat transfer and 
  # multiply by the exposed area to calculate actual heat transfer by conduction
}
