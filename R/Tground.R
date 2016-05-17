Tground<-function(Ta=20, SE=100){
  # Empirical relationship of measured Tg vs. SE allow for a Delta T (Tg - T) to be 
  # estimated.  
  # Bartlett et al's results claiming a slope of 0.0121
  # Source: Bartlett et al. 2006.  A Decade of Ground–Air Temperature Tracking at Emigrant
  # Pass Observatory, Utah.  Journal of Climate.  19: 3722-3731
  # We have measured a slope of 0.0187127 
  Tground<-0.0121*SE+Ta
  #names(Tground)<-"Tground"
  Tground
}
