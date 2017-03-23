#' @export
#' 
Nusseltfree<-function(a=NULL, b=NULL, m=NULL, L=0.1, Ts=25, Ta=20, shape="hcylinder"){
  
  # Gr is the Grashof number as determined by Grashof() function
  # which requires info on L, Ts, Ta and v
  # a, b & m are experimentally determined and vary with shape
  # default values of a = 1, b=0.58, m=0.25 (0.25 for laminar)
  # b is 0.58 for upright cylinders
  # b is 0.48 for horizontal cylinders
  # m is 0.25 for laminar flow
  
  if(is.null(a)) a<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$a
  if(is.null(b)) b<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$b
  if(is.null(m)) m<-freeparameters(L=L, Ts=Ts, Ta=Ta, shape=shape)$m
  
  # Source: Blaxter, K. 1989.  Energy Metabolism in Animals and Man
  
  Nu<-b*(Grashof(L, Ts, Ta)*Prandtl(Ta)^a)^m
  names(Nu)<-NULL
  Nu
  }
