#' @export
#' 
Lu<-function(Tg=20, Eground=0.97){
  # Terrain emissivities vary from 0.89 (sand, snow) to 0.97 (moist soil) - Blaxter, 1986
  GT <- Tg + 273.15
  Lu<-Eground*StephBoltz()*(GT)^4
  Lu
}
