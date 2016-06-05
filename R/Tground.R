Tground<-function(Ta=20, SE=100){
  # Empirical relationship of measured Tg vs. SE allow for a Delta T (Tg - T) to be 
  # estimated.  
  # Bartlett et al's results claiming a slope of 0.0121
  # Compare to my own empirical measurements with a slope of 0.0187127 
  Tground<-0.0121*SE+Ta
  #names(Tground)<-"Tground"
  Tground
}
