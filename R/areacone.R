#' @export
#' 
areacone<-function(Radius, radius=Radius, hypotenuse=NULL, height, ends=1){
  if(is.null(hypotenuse)){
    hypotenuse<-sqrt(height^2+Radius^2)
  }
  Area <- ends*pi*Radius*radius + pi*Radius*hypotenuse
  Area
}
