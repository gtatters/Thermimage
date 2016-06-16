airspecificheat<-function(Ta=20){
  # Specific heat capacity of air
  # Units: J/(kg*K)
  # http://www.engineeringtoolbox.com/air-properties-d_156.html
  # Quadratic Polynomial Regression for -150 to 400oC range, regression fit against
  # temperature in Celsius, r2=0.994
  
  Intercept<-1.003731424
  Slope1<-5.37909E-06	
  Slope2<-7.30124E-07	
  Slope3<-(-1.34472E-09)
  Slope4<-1.23027E-12
  
  cp<-1000*(Intercept + Slope1*Ta + Slope2*Ta^2 + Slope3*Ta^3 + Slope4*Ta^4)
  # multiply by 1000 to convert to J from kJ
  cp
  }
