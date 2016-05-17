Prandtl<-function(Ta=20){
  
  # from http://www.engineeringtoolbox.com/air-properties-d_156.html
  Temp<-c(-50, -25, 0, 20, 40, 60, 80, 90, 100)
  Pr<-c(0.7250, 0.72, 0.715, 0.713, 0.711, 0.709, 0.707, 0.7055, 0.703)
  lm<-lm(Pr~poly(Temp, 6))
  Prandtl<-predict(lm, newdata=data.frame(Temp=Ta), interval="none")
  names(Prandtl)<-NULL
  Prandtl

  }
