Nusseltforced<-function(a=0.24, n=0.6, V=1, L=1, Ta=20){
  
  # Calls the Reynolds() function, which needs V, L and v
  # V: air velocity in m/s
  # L: is the characteristic dimension, usually the vertical dimension.  For reference, 
  # a cylinder's characteristic L would be its height, assuming it is standing on its end
  # This L should be the same L as is used for the convective coefficient calculation
  # v: is the kinematic viscosity using function airviscosity(Ta)
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
  v<-airviscosity(Ta) 
  Nu<-a*Reynolds(V,L,v)^n
  Nu}

