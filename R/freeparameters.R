#' @export
#' 
freeparameters<-function(L=0.1, Ts=30, Ta=20, shape="hcylinder"){
  # shape can be "sphere", "hplate", "vplate", or "hcylinder" or "vcylinder"
  # the letter v or h denotes vertical or horizontal orientation but is only used in the free
  # parameters call
  
  a<-1 # most cases, a will be 1, except for one turbulent situation (not implemented)
  Gr<-Grashof(L=L, Ts=Ts, Ta=Ta)
  Pr<-Prandtl(Ta)
  b<-rep(NA, length(shape))
  m<-rep(NA, length(shape))
  ind<-shape=="hcylinder"
    b[ind]<-0.53; m[ind]<-0.25
  ind<-shape=="vcylinder"
   b[ind]<-0.726; m[ind]<-0.25
  ind<-shape=="hplate"
    b[ind]<-0.710; m[ind]<-0.25 #note: this is for a warm plate facing upward
  ind<-shape=="vplate"
    b<-0.523; m<-0.25
  ind<-shape=="sphere"
    b<-0.58; m<-0.25
  
  coeffs<-list(a,b,m)
  names(coeffs)<-c("a","b","m")
  coeffs
}

