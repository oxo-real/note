#! /usr/bin/env sh

## from: note/linux/arch/icons/cursor
## reset oxo cursor setup
pilot="$XDG_CONFIG_HOME"/icons/cursors/oxo/pilot
copilot="$XDG_CONFIG_HOME"/icons/cursors/oxo/copilot
usiac=/usr/share/icons/Adwaita/cursors

sudo mount -o remount,rw /usr

## copy cursor shapes to usiac
sudo cp "$pilot" "$usiac"
sudo cp "$copilot" "$usiac"

## backup original cursor shapes
[[ -f "$usiac"/text ]] && sudo cp "$usiac"/text "$usiac"/text_ORG
[[ -f "$usiac"/xterm ]] && sudo cp "$usiac"/xterm "$usiac"/xterm_ORG
[[ -f "$usiac"/default ]] && sudo cp "$usiac"/default "$usiac"/default_ORG
[[ -f "$usiac"/left_ptr ]] && sudo cp "$usiac"/left_ptr "$usiac"/left_ptr_ORG
[[ -f "$usiac"/hand2 ]] && sudo cp "$usiac"/hand2 "$usiac"/hand2_ORG

## symlink cursor shapes to (co)pilot
## CAUTION overwrites existing files
sudo ln -s -f "$usiac"/pilot "$usiac"/text
sudo ln -s -f "$usiac"/pilot "$usiac"/xterm
sudo ln -s -f "$usiac"/copilot "$usiac"/default
sudo ln -s -f "$usiac"/copilot "$usiac"/left_ptr
sudo ln -s -f "$usiac"/copilot "$usiac"/hand2

sudo mount -o remount,ro /usr
