areacylinder<-function(Radius, radius=Radius, height, ends=2){
  Area <- (Radius+radius)*pi*height + ends*pi*Radius*radius
  Area
}
