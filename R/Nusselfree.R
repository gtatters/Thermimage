Nusseltfree<-function(b=0.58, m=0.25, L=1, Ts=20, Ta=20){
  
  # Gr is the Grasshof number as determined by Grasshof() function
  # which requires info on L, Ts, Ta and v
  # b & m are experimentally determined and vary with shape
  # b is 0.58 for upright cylinders
  # b is 0.48 for horizontal cylinders
  # m is 0.25 for laminar flow
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
  
  Nu<-b*Grasshof(L, Ts, Ta)^m
  Nu}
