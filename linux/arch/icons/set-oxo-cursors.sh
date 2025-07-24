#! /usr/bin/env sh

# set oxo cursor shapes

## see: note/linux/arch/icons/cursor

## files wiil be replaced in:
usiac=/usr/share/icons/Adwaita/cursors

## oxo xcursor files location
cico="$XDG_CONFIG_HOME"/icons/cursors/oxo

## oxo xcursor files (generated woth xcursorgen)
copilot="$cico"/copilot
co_all_scroll="$cico"/co-all-scroll
co_grab="$cico"/co-grab
co_grabbing="$cico"/co-grabbing
pilot="$cico"/pilot
plus="$cico"/plus
co_pointer="$cico"/co-pointer

## check if symlink in cico exist
[[ -L "$copilot" ]] || exit 1
[[ -L "$co_all_scroll" ]] || exit 5
[[ -L "$co_grab" ]] || exit 3
[[ -L "$co_grabbing" ]] || exit 4
[[ -L "$co_pointer" ]] || exit 7
[[ -L "$pilot" ]] || exit 2
[[ -L "$plus" ]] || exit 6

sudo mount -o remount,rw /usr

## backup original usiac cursor shapes
[[ -f "$usiac"/all-scroll ]] && sudo cp "$usiac"/all-scroll "$usiac"/all-scroll_ORG
[[ -f "$usiac"/crosshair ]] && sudo cp "$usiac"/crosshair "$usiac"/crosshair_ORG
[[ -f "$usiac"/cell ]] && sudo cp "$usiac"/cell "$usiac"/cell_ORG
[[ -f "$usiac"/default ]] && sudo cp "$usiac"/default "$usiac"/default_ORG
[[ -f "$usiac"/grab ]] && sudo cp "$usiac"/grab "$usiac"/grab_ORG
[[ -f "$usiac"/grabbing ]] && sudo cp "$usiac"/grabbing "$usiac"/grabbing_ORG
[[ -f "$usiac"/hand2 ]] && sudo cp "$usiac"/hand2 "$usiac"/hand2_ORG
[[ -f "$usiac"/left_ptr ]] && sudo cp "$usiac"/left_ptr "$usiac"/left_ptr_ORG
[[ -f "$usiac"/pointer ]] && sudo cp "$usiac"/pointer "$usiac"/pointer_ORG
[[ -f "$usiac"/text ]] && sudo cp "$usiac"/text "$usiac"/text_ORG
[[ -f "$usiac"/xterm ]] && sudo cp "$usiac"/xterm "$usiac"/xterm_ORG

## symlink cursor shapes to oxo xcursor files
## CAUTION overwrites existing files (therefore previous backup)
sudo ln -s -f "$copilot" "$usiac"/default
sudo ln -s -f "$copilot" "$usiac"/hand2
sudo ln -s -f "$copilot" "$usiac"/left_ptr
sudo ln -s -f "$co_all_scroll" "$usiac"/all-scroll
sudo ln -s -f "$co_grab" "$usiac"/grab
sudo ln -s -f "$co_grabbing" "$usiac"/grabbing
sudo ln -s -f "$pilot" "$usiac"/text
sudo ln -s -f "$pilot" "$usiac"/xterm
sudo ln -s -f "$plus" "$usiac"/crosshair
sudo ln -s -f "$plus" "$usiac"/cell
sudo ln -s -f "$co_pointer" "$usiac"/pointer

sudo mount -o remount,ro /usr
