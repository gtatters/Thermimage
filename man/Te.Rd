\name{Te}
\alias{Te}
\title{
Operative temperature estimate.
}
\description{
Operative temperature (degrees Celsius) is a measure of the effective temperature an object/animal will be given a specific radiative and convective environment.  Basal heat production and evaporative heat loss are assumed to balance each other out.  
}
\usage{
Te(Ts=30, Ta=25, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=0, V=1, 
L=0.1, c=NULL, n=NULL, a=NULL, b=NULL, m=NULL, type="forced", shape="hcylinder")
}
\arguments{
  \item{Ts}{
Surface temperature (degrees Celsius). Default value is 30.  Used in free convection calculation.
  }
  \item{Ta}{
Air temperature (degrees Celsius).  Default value is 20.  Used to estimate ground temperature if Tg is unavailable.
}
  \item{Tg}{
Ground temperature (degrees Celsius).  Default value is NULL, but a measured Tg can be substituted or estimated with other functions.
}
  \item{RH}{
Relative humidity (fraction 0 to 1).  Default value is 0.5.  Used in call to Ld() to determine incoming radiation.
}
  \item{E}{
Emissivity (fraction 0 to 1) of the object absorbing longwave radiation.  According to Kirschoff's law, emissivity = absorptivity.  Absorptivity is multiplied by the average of the incoming longwave radiation to estimate absorbed radiation.
}
  \item{rho}{
Reflectivity (fraction 0 to 1) of the object absorbing solar radiation.  Used to modify absorbed solar energy.  Default is 0.1.  
}
  \item{cloud}{
Fractional cloud cover (fraction from 0 to 1).  Used in call to Ld() to determine incoming radiation.  Default is 0.
}
  \item{SE}{
Solar energy (W/m2), usually measured.  Default is 100.
}
 \item{V}{
Air velocity (m/s).  Default value is 1.
}
  \item{L}{
Characteristic dimension (m) of object.  Usually the vertical dimension (i.e. height). Default value is 1.
}
  \item{c}{
coefficient used in forced convection (see Blaxter, 1986, default value is 0.24)
}
  \item{n}{
coefficient used in forced convection (see Blaxter, 1986, default value is 0.6)
}
 \item{a}{
coefficient used in free convection (see Gates, 2003, default value is 1)
}
  \item{b}{
coefficient used in free convection (0.58 upright cylinder, 0.48 flat cylinder, default value is 0.58)
}
  \item{m}{
coefficient used in free convection (0.25 laminar flow, default value is 0.25)
}
  \item{type}{
"forced" or "free" - to calculate convection coefficient for either forced or free convection.  Default value is "forced"
}
\item{shape}{
"sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}
\details{
Estimates operative temperature according to calculations in Gates (2003) and Angiletta ()
}

\references{
Angiletta, M. J.  2009.  Thermal Adaptation: A Theoretical and Empirical Synthesis. Oxford University Press, Oxford, UK, 304 pp.
Gates, D.M. 2003.  Biophysical Ecology.  Courier Corporation, 656 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{qabs}}
\code{\link{hconv}}
}
\examples{
## The function is currently defined as
function (Ts=30, Ta=25, Tg=NULL, RH=0.5, E=0.96, rho=0.1, cloud=0, SE=0, V=1,
L=0.1, c=NULL, n=NULL, a=NULL, b=NULL, m=NULL, type="forced", shape="hcylinder")
{
    Te <- Ta + (qabs(Ta=Ta, Tg=Tg, RH=RH, E=E, rho=rho, cloud=cloud,
    SE=SE) - StephBoltz()*0.96*(Ta+273.15)^4) / 
    (hconv(Ts=Ts, Ta=Ta, V=V, L=L, c = NULL, n = NULL, a = NULL, b = NULL, m = NULL,
    type=type, shape=shape) + 4*StephBoltz()*0.96*(Ta+273.15)^3)
    Te
  }

# Example

Ts<-40
Ta<-30
SE<-seq(0,1500,100)
Toperative<-NULL
for(rho in seq(0, 1, 0.1)){
  temp<-Te(Ts=Ts, Ta=Ta, Tg=NULL, RH=0.5, E=0.96, rho=rho, cloud=1, SE=SE, V=0.1, 
           L=0.1, type="free", shape="hcylinder")
  Toperative<-cbind(Toperative, temp)
}
Toperative<-data.frame(SE=seq(0,1500,100), Toperative)
colnames(Toperative)<-c("SE", seq(0,1,0.1))
matplot(Toperative$SE, Toperative[,-1], ylim=c(30, 50), type="l", xlim=c(0,1000),
        ylab="Operative Temperature (C)", xlab="Solar Radiation (W/m2)", lty=1,
        col=flirpal[rev(seq(1,380,35))])


}

