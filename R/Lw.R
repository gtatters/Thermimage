#' @export
#' 
Lw <- function(Ta=20, RH=0.5, n=0.5){
  # Longwave radiation downward to surface.  Units: W/m2
  # Alternative to Ld(), derived from Gabathuler et al 2001.  Parameterization of incoming longwave
  # radiation in high mountain environments.  Physical Geography 22: 99-114
  # Terms used are similar to the Ld function, but Gabathuler refers to them differently
  # n is a clearness index (1 = full cloud, 0 = clear sky), similar to Ko used in Ld()
  # RH.pct (i.e. RH*100) is relative humidity in percent
  # AT is air temperature in Kelvin
  AT <- Ta + 273.15
  RH.pct<-RH*100
  Ko<-n
  Lw<-StephBoltz()*(-21*Ko + AT)^4 + 0.84*RH.pct - 57
  Lw
}
