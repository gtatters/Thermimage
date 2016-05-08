Reynolds<-function(V=1, L=1, v=airviscosity(20)){
  # Reynolds number is a dimensionaless representation of air velocity
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
  # V: air velocity in m/s
  # L: is the characteristic dimension, usually the vertical dimension.  For reference, 
  # a cylinder's characteristic L would be its height, assuming it is standing on its end
  # This L should be the same L as is used for the convective coefficient calculation
  # v: is the kinematic viscosity using function airviscosity(Ta)
  Re<-V*L/v
  Re
  }
