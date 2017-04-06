#' @export
#' 
airtconductivity<-function(Ta=20){
  # Thermal conductivity of air, as a function of temperature
  # Units: W/m/K
  # http://www.engineeringtoolbox.com/air-properties-d_156.html
  # Regression for 0 to 100oC range:
  Intercept<-0.024280952
  Slope<-7.07143E-05
  k<-Intercept+Slope*Ta
  k
  }
