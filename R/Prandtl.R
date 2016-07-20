Prandtl<-function(Ta=20){
  
  # from http://www.engineeringtoolbox.com/air-properties-d_156.html
  Temp<-c(-50, -25, 0, 20, 40, 60, 80, 90, 100)
  Temp2<-Temp^2
  Temp3<-Temp^3
  Temp4<-Temp^4
  Temp5<-Temp^5
  Temp6<-Temp^6
  Pr<-c(0.7250, 0.72, 0.715, 0.713, 0.711, 0.709, 0.707, 0.7055, 0.703)
  # Note: updated this formula after uploading v2.1 to Cran.
  # will have to include this as a patch since the poly function conflicts with other 
  # packages
  # lm1<-stats::lm(Pr ~ Temp + Temp2 + Temp3 + Temp4 + Temp5 + Temp6)
  # coeffic<-stats::coefficients(lm1)
  coeffic<-c(7.150428e-01, -1.347949e-04, 2.117136e-06, -3.099238e-08, -3.050327e-10,
             1.001365e-11, -5.839058e-14)
  Prandtl<-coeffic[1] + coeffic[2]*Ta + coeffic[3]*Ta^2 + coeffic[4]*Ta^3 + coeffic[5]*Ta^4 + 
    coeffic[6]*Ta^5 + coeffic[7]*Ta^6
  #Prandtl<-predict(lm, newdata=data.frame(Temp=Ta), interval="none")
  names(Prandtl)<-NULL
  Prandtl

  }
