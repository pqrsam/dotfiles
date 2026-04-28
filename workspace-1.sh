#!/bin/bash

i3-msg "workspace 1; append_layout ~/.config/workspace-1/workspace-1.json"

kitty -e bash -c 'neofetch; exec bash' & 
sleep 0.4
kitty -e bash -c 'vtop -t becca; exec bash' & 
sleep 0.4
kitty -e bash -c 'tty-clock -c -C 5; exec bash' & 
sleep 0.4
kitty -e bash -c 'vis; exec bash' & 
sleep 0.4
kitty -e bash -c 'cmatrix -C magenta; exec bash' &
