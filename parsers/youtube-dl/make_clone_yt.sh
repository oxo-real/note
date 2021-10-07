#!/bin/bash

sudo apt update

sudo apt install python3-pip

pip3 install requests lxml cssselect argparse

##sudo apt upgrade

##sudo reboot

sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl

sudo chmod a+rx /usr/local/bin/youtube-dl

sudo ln -sf /usr/bin/python3 /usr/bin/python

## copy clone_yt.sh and yt_comments.py to the Ubuntu environment

## find Windows10 username from env
full_path=$(env | grep -i PATH)
indicator="/mnt/c/Users/"
un_rgt_bound="/"

### get start position of indicator
start_pos=$(echo $full_path | grep -o -b $indicator | awk -F : '{print $1}')
### get length of indicator
length_str_to_find=$(echo $indicator | wc -c)
### get start position of username
un_start_pos=$(( start_pos + length_str_to_find ))
### get the string from start position to next / (sed removes all after '/')
username="$(echo $full_path | cut -c $un_start_pos- | sed -e 's/\/.*//')"

## set directories
w10_home="$indicator$username"
w10_target=$w10_home/Documents/clone_yt_data
w10_script=$HOME/clone_yt

## make script directory
mkdir -p $w10_script

## set target data file
echo $w10_target > $w10_script/w10_target.txt

gitlab="https://gitlab.com/cytopyge/notes/raw/master/parsers/youtube-dl"
sudo curl -L $gitlab/clone_yt.sh -o $w10_script/clone_yt.sh
sudo curl -L $gitlab/yt_comments.py -o $w10_script/yt_comments.py

ln -sf $w10_script/clone_yt.sh clone_yt.sh
ln -sf $w10_script/yt_comments.py yt_comments.py