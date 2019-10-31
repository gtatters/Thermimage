#' @export
#' 
temp2raw <-
function(temp,E=1,OD=1,RTemp=20,ATemp=RTemp,IRWTemp=RTemp,IRT=1,RH=50,
                   PR1=21106.77,PB=1501,PF=1,PO=-7340,PR2=0.012545258,
         ATA1=0.006569, ATA2=0.01262, ATB1=-0.002276, ATB2=-0.00667, ATX=1.9)
{
  # This function is complementary to the raw2temp command,
  # except it converts a temperature estimate (in deg C) into a raw value
  # The temperature estimate would already have been obtained during analysis 
  # from a thermal imaging program under known atmospheric conditions
  # Temp should be supplied in degrees Celsius
  
  # how to call this function: 
  # temp2raw(temp,E,OD,RTemp,ATemp,IRWTemp,IRT,RH,PR1,PB,PF,PO,PR2)
  # example with all settings at default/blackbody levels
  # temp2raw(25,1,0,20,20,20,1,50,PR1,PB,PF,PO,PR2)
  # example with emissivity=0.95, distance=1m, window transmission=0.96, all temperatures=20C, 50% relative hum
  # temp2raw(20,0.95,1,20,20,20,0.96,50)  # default calibration constants for my FLIR camera will be used
  
  # Note: PR1, PR2, PB, PF, and PO are specific to each camera and result from the calibration at factory
  # of the camera's Raw data signal recording from a blackbody radiation source
  # Calibration Constants                 (Glenn's FLIR, Ray's T300(25o) Ray's, T300(telephoto), Glenn's Mikron )
  # PR1: PlanckR1 calibration constant from FLIR file  21106.77       14364.633     14906.216       21106.77
  # PB: PlanckB calibration constant from FLIR file    1501           1385.4        1396.5          9758.743281
  # PF: PlanckF calibration constant from FLIR file    1              1             1               29.37648768
  # PO: PlanckO calibration constant from FLIR file    -7340          -5753         -7261           1278.907078
  # PR2: PlanckR2 calibration constant form FLIR file  0.012545258    0.010603162   0.010956882     0.0376637583528285
  
  # Set constants below. Comment out those that are variables in this function
  # Keep those that should remain constants.  These are here to make troubleshooting calculations easier
  # temp<-25; E<-0.95; OD<-20; IRT<-0.96
  # RTemp<-20; IRWTemp<-RTemp; ATemp<-20; RH<-50
  # PR1<-21106.77; PB<-1501; PF<-1; PO<--7340; PR2<-0.012545258
  
  # Equations to convert to temperature
  # See http://130.15.24.88/exiftool/forum/index.php/topic,4898.60.html
  # Standard equation: temperature<-PB/log(PR1/(PR2*(raw+PO))+PF)-273.15
  # Other source of information: Minkina and Dudzik's Infrared Thermography: Errors and Uncertainties
  
  emiss.wind<-1-IRT
  refl.wind<-0 # anti-reflective coating on window
  h2o<-(RH/100)*exp(1.5587+0.06939*(ATemp)-0.00027816*(ATemp)^2+0.00000068455*(ATemp)^3)
  # converts relative humidity into water vapour pressure (I think in units mmHg)
  tau1<-ATX*exp(-sqrt(OD/2)*(ATA1+ATB1*sqrt(h2o)))+(1-ATX)*exp(-sqrt(OD/2)*(ATA2+ATB2*sqrt(h2o)))
  tau2<-ATX*exp(-sqrt(OD/2)*(ATA1+ATB1*sqrt(h2o)))+(1-ATX)*exp(-sqrt(OD/2)*(ATA2+ATB2*sqrt(h2o)))
  # transmission through atmosphere - equations from Minkina and Dudzik's Infrared Thermography Book
  
  raw.obj<-PR1/(PR2*(exp(PB/(temp+273.15))-PF))-PO
  
  raw.refl1<-PR1/(PR2*(exp(PB/(RTemp+273.15))-PF))-PO   # radiance reflecting off the object before the window
  raw.refl1.attn<-(1-E)/E*raw.refl1   # attn = the attenuated radiance (in raw units) 
  
  raw.atm1<-PR1/(PR2*(exp(PB/(ATemp+273.15))-PF))-PO # radiance from the atmosphere (before the window)
  raw.atm1.attn<-(1-tau1)/E/tau1*raw.atm1 # attn = the attenuated radiance (in raw units) 
  
  raw.wind<-PR1/(PR2*(exp(PB/(IRWTemp+273.15))-PF))-PO
  raw.wind.attn<-emiss.wind/E/tau1/IRT*raw.wind
  
  raw.refl2<-PR1/(PR2*(exp(PB/(RTemp+273.15))-PF))-PO   
  raw.refl2.attn<-refl.wind/E/tau1/IRT*raw.refl2
  
  raw.atm2<-PR1/(PR2*(exp(PB/(ATemp+273.15))-PF))-PO
  raw.atm2.attn<-(1-tau2)/E/tau1/IRT/tau2*raw.atm2
  
  raw<-(raw.obj+raw.atm1.attn+raw.atm2.attn+raw.wind.attn+raw.refl1.attn+raw.refl2.attn)*E*tau1*IRT*tau2
  
  raw
}
