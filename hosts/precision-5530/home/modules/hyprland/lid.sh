#!/usr/bin/env zsh

if [[ "$(hyprctl monitors)" =~ "\sDP-[0-9]+" ]]; then
  if [[ $1 == "open" ]]; then
    hyprctl keyword monitor "eDP-1,3840x2160,0x0,2"
  else
    hyprctl keyword monitor "eDP-1,disable"
  fi
fi
