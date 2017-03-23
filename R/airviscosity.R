#' @export
#' 
airviscosity<-function(Ta=20){
  # Kinematic viscosity of air, as a function of temperature
  # Units: m2/s
  # http://www.engineeringtoolbox.com/air-properties-d_156.html
  # Regression for 0 to 100oC range:
  Intercept<-13.17380952
  Slope<-0.097457143
  k<-(Intercept+Slope*Ta)*1e-6 #  multiply by 1e-6 to get into m2/s units
  k
  }
