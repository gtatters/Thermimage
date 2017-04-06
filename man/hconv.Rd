\name{hconv}
\alias{hconv}
\title{
Convective heat coefficient (W/m2/oC)
}
\description{
Calculates the convective heat coefficient for an object of known dimensions, and given various physical parameters, typically only for laminar flow.
}
\usage{
hconv(Ts=30, Ta = 20, V = 1, L = 0.1, c = NULL, n = NULL, a = NULL, b = NULL, m = NULL, 
type = "forced", shape="hcylinder")
}
\arguments{
  \item{Ts}{
Surface temperature (degrees celsius). Required for free convection function call.  Default value is 30.  
}
  \item{Ta}{
Air temperature (degrees celsius). Default value is 20.
}
  \item{V}{
Air velocity (m/s).  Default value is 1.
}
  \item{L}{
Characteristic dimension (m) of object.  Usually the vertical dimension (i.e. height). Default value is 0.1.
}
  \item{c}{
coefficient used in forced convection (see Gates, 2003). Default value is NULL, typical values is 0.24)
}
  \item{n}{
coefficient used in forced convection (see Gates, 2003). Default value is NULL, typical value is 0.6)
}
  \item{a}{
  coefficient used in forced convection (see Gates, 2003). Default value is NULL, typical value is 1.
  }
  \item{b}{
coefficient used in free convection (see Gates, 2003). Default value is NULL, typical value is 0.58 for upright cylinder, 0.48 for horizontal cylinder.
}
  \item{m}{
coefficient used in free convection.  Default is NULL.  For laminar flow, m=0.25
}
  \item{type}{
"forced" or "free" - to calculate convection coefficient for either forced or free convection.  Default value is "forced"
}
\item{shape}{
"sphere", "hplate", "vplate", "hcylinder", "vcylinder" to denote shape and orientation.  h=horizontal, v=vertical.  Default shape is "hcylinder"
}
}
\details{
Calculates the convection coefficient for heat transfer estimation by estimating Nusselt's number.  Used in conjunction with known temperature differences in order to estimate heat transfer via convection.  Gates advises to use "forced" convection coefficients down to 0.1 m/s as appropriate for very low air flow rates, rather than distinguishing between "free" and "forced" convection.  Nussel's number depends on whether forced or free convection is specified.  There may be some conditions (i.e. combinations of wind speeds, critical dimensions) where Nusselt's numbers are unspecified, since these values fall outside the range of Reynold's number for which estimates of convection coefficients are plausible.

Caution is advised when using hconv without considering the assumptions of convective heat exchange, and users are advised to check with Gates (2003) to see if estimates provided with this function are within the predicted range.   
}
\value{
A value corresponding to the convection coefficient, units: W/m/oC.
}
\references{
Blaxter, 1986.  Energy metabolism in animals and man.  Cambridge University Press, Cambridge, UK, 340 pp.

Gates, DM. 2003.  Biophysical Ecology.  Dover Publications, Mineola, New York, 611 pp.
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{qconv}}
}
\examples{

## The function is currently defined as
function (Ts=30, Ta = 20, V = 1, L = 0.1, c = NULL, n = NULL, a = NULL, b = NULL, 
    m = NULL, type = "forced", shape="hcylinder") 
{
    if (V == 0) 
        type <- "free"
    if (type == "forced" | type == "Forced") 
        Nu <- Nusseltforced(c = c, n = n, V = V, L = L, Ta = Ta, shape="hcylinder")
    if (type == "free" | type == "Free") 
        Nu <- Nusseltfree(a = a, b = b, m = m, L = L, Ts = Ts, Ta = Ta, shape="hcylinder")
    k <- airtconductivity(Ta)
    hconv <- Nu * k/L
    hconv
  }
  

}
