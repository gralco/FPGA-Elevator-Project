#!/bin/bash

export PROJ=${PROJ:-elevator}
export TIME=${TIME:-500ms}

ghdl --remove
# Import (instructor called it "compile" in udemy course)
ghdl -i $PROJ.vhd t_$PROJ.vhd
# Make (instructor called it "elaboration" in udemy course)
ghdl -m t_$PROJ
# Run
ghdl -r t_$PROJ --stop-time=$TIME --wave=t_$PROJ.ghw

# Open GTKWave
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	gtkwave t_$PROJ.ghw
elif [[ "$OSTYPE" == "msys"* ]]; then
	gtkwave-gtk3 t_$PROJ.ghw
fi

# Analyze, elaborate, and synthesize
yosys $MODULE -p 'ghdl --latches pck_myhdl_081.vhd '"$PROJ"'.vhd -e '"$PROJ"'; synth_ice40 -json '"$PROJ"'.json'
# P&R
nextpnr-ice40 --package hx1k --pcf $PROJ.pcf --asc $PROJ.asc --json $PROJ.json --pcf-allow-unconstrained --ignore-loops
# Generate bitstream
icepack $PROJ.asc $PROJ.bin
# Pause, wait for input to say it's ok to program
while true; do

read -p "Do you want to program the FPGA? [Y/n] " Yn

case $Yn in
	""|yes|Yes|YeS|YEs|YES|[yY] ) iceprog $PROJ.bin;
		break;;
	no|nO|No|NO|[nN] ) echo Not programming...;
		exit;;
	* ) echo Invalid response, try again...;;
esac

done
