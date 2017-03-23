#' @export
#' 
Nusseltforced<-function(c=NULL, n=NULL, V=1, L=0.1, Ta=20, shape="hcylinder"){
  
  # typical value for c and n are: 0.24 and 0.6
  # default values for c and n are set to NULL, to force the call to forcedparameters
  # but this allows the user to override with known a and n values
  # Calls the Reynolds() function, which needs V, L and v
  # V: air velocity in m/s
  # L: is the characteristic dimension, usually the vertical dimension.  For reference, 
  # a cylinder's characteristic L would be its height, assuming it is standing on its end
  # This L should be the same L as is used for the convective coefficient calculation
  # v: is the kinematic viscosity using function airviscosity(Ta)
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
  if(is.null(c)) c<-forcedparameters(V=V, L=L, Ta=Ta, shape=shape)$c
  if(is.null(n)) n<-forcedparameters(V=V, L=L, Ta=Ta, shape=shape)$n
  v<-airviscosity(Ta)
  Re<-Reynolds(V,L,v)
  Nu<-c*Re^n
  names(Nu)<-NULL
  Nu
  }

