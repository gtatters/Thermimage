palette.choose<-
  function(colscheme)
  {
    #------ Set the colour palette to be used --------------
    # for use with image.plot or other compatible raster packages 
    
    if(colscheme=="flir")
    {
      #data(flirpal)
      palhex<-flirpal
    }
    
    if(colscheme=="glowbow")
    {
      #data(glowbowpal)
      palhex<-glowbowpal
    }
    
    if(colscheme=="grey120")
    {
      #data(grey120pal)
      palhex<-grey120pal      
    }
    
    if(colscheme=="grey10")
    {
      #data(grey10pal)
      palhex<-grey10pal
    }
    
    if(colscheme=="greyred")
    {
      #data(greyredpal)
      palhex<-greyredpal
    }
    
    if(colscheme=="hotiron")
    {
      #data(hotironpal)
      palhex<-hotironpal
    }
    
    if(colscheme=="ironbow")
    {
     # data(ironbowpal)
      palhex<-ironbowpal
    }
    
    if(colscheme=="medical")
    {
      #data(medicalpal)
      palhex<-medicalpal
    }
    
    if(colscheme=="midgreen")
    {
     # data(midgreenpal)
      palhex<-midgreenpal
    }
    
    if(colscheme=="midgrey")
    {
     # data(midgreypal)
      palhex<-midgreypal
    }
    
    if(colscheme=="mikronprism")
    {
      #data(mikronprismpal)
      palhex<-mikronprismpal
    }
    
    if(colscheme=="mikroscan")
    {
     # data(mikroscanpal)
      palhex<-mikroscanpal
    }
    
    if(colscheme=="rainbowpal")
    {
     # data(rainbowpal)
      palhex<-rainbowpal
    }
    
    if(colscheme=="yellowpal")
    {
      #data(yellowpal)
      palhex<-yellowpal
    }
    palhex
  }
