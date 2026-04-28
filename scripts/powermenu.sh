#!/bin/bash

choice=$(echo -e " Shutdown\n Reboot\n Logout\n Lock" | rofi -dmenu -i -p "Power")

case "$choice" in
  " Shutdown")
    systemctl poweroff
    ;;
  " Reboot")
    systemctl reboot
    ;;
  " Logout")
    i3-msg exit
    ;;
  " Lock")
    betterlockscreen -l
    ;;
esac
