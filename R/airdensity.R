#' @export
#' 
airdensity<-function(Ta=20){
  # Air density (p, or rho) as a function of temperature (Celsius)
  # Units: kg/m3
  # http://www.engineeringtoolbox.com/air-properties-d_156.html
  # Regression for -150 to 400oC range, fits a negative power 
  # if temperature in Kelvin is used.  r2=0.998:
  
  Base<-314.156
  Exponent<- (-0.981)
  p<-Base*(Ta+273.15)^Exponent
  p
  }
