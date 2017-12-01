# from http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=4898.45
#!/bin/bash
echo "usage $0 flir.jpg PixelArea" 
echo "usage ./raw2temp.sh IR_1546.jpg  1x1+0+0"
echo "see imagemagick crop for PixelArea, sample 1x1+0+0"

# get Flir values
Flir=$(exiftool -Flir:all "$1")
Type=$(echo "$Flir" | grep "Raw Thermal Image Type" | cut -d: -f2)
if [ "$Type" != " TIFF" ]
then 
echo "only for RawThermalImage=TIFF"
exit 1
fi

R1=$(echo "$Flir" | grep "Planck R1" | cut -d: -f2)
R2=$(echo "$Flir" | grep "Planck R2" | cut -d: -f2)
B=$(echo "$Flir" | grep "Planck B" | cut -d: -f2)
O=$(echo "$Flir" | grep "Planck O" | cut -d: -f2)
F=$(echo "$Flir" | grep "Planck F" | cut -d: -f2)

# get RAW Sensor value
RAW=$(exiftool -b -RawThermalImage "$1" 2>/dev/zero | convert - -crop $2 -colorspace gray -format "%[mean]" info: )

# calc spectral range of used Flir camera
echo -n "spectral range [micrometer]: "
echo "scale=2;14387.6515/$B"| bc -l 

# calc Temperature of PixelArea with Emissivity = 1.0
degree=$(echo "scale = 8;$B/l($R1/($R2*($RAW+$O))+$F)-273.15" | bc -l )
echo "$RAW RAW => $degree degree Celsius at Emissivity=1.0"

# calc Temperature of PixelArea with saved Emissivity
Emissivity=$(echo "$Flir" | grep "Emissivity" | cut -d: -f2)
Refl_Temp=$(echo "$Flir" | grep "Reflected Apparent Temperature" | sed 's/[^0-9.-]*//g')

RAWrefl=$(echo "scale = 8;$R1/($R2*(e($B/($Refl_Temp+273.15))-$F))-$O" | bc -l )
RAWobj=$(echo "scale = 8;($RAW-(1-$Emissivity)*$RAWrefl)/$Emissivity" | bc -l )
echo $Emissivity $Refl_Temp $RAW $RAWrefl $RAWobj
degree=$(echo "scale = 8;$B/l($R1/($R2*($RAWobj+$O))+$F)-273.15" | bc -l )
echo "$RAWobj RAW => $degree °C at Emissivity=$Emissivity and $Refl_Temp °C reflected temp."