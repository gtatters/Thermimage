slopebypoint <-
function(data) 
{
  t<-seq(0,length(data)-1,1)
  s<-lm(data~t)$coef[2]
  names(s)<-NULL
  s<-s
}


