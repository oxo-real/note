#!/bin/bash
#
##
###
###       _                            _
###   ___| | ___  _ __   ___     _   _| |_
###  / __| |/ _ \| '_ \ / _ \   | | | | __|
### | (__| | (_) | | | |  __/   | |_| | |_
###  \___|_|\___/|_| |_|\___|____\__, |\__|
###                        |_____|___/
###
###  _ _|_ _ ._    _  _
### (_\/|_(_)|_)\/(_|(/_
###   /      |  /  _|
###
### clone_yt
### download youtube data;
### videos, descriptions, info, annotations, thumbnails, subtitles and comments
### comments (via python call) after egbertbouwman, thanks
###
### (c) 2019 - 2020 cytopyge
###
##
#

#
##
### usage: clone_yt -u <uri> [ -o <output_dir> ]
###
### for logging add: '| tee -a <output_dir>/000_clone_yt.log'
###
### deps: (python) pip requests lxml cssselect argparse
###
##
#


# initialization

script_name="clone_yt"
script_usage="$script_name -u <uri> [-o <output_dir>]"
script_dir=`pwd`

timestamp=`date +%Y%m%d_%H%M%S`
clear


# define colors
RED='\033[0;31m' # red
GREEN='\033[0;32m' # green
NOC='\033[0m' # no color


# read_flags

while getopts ":u:o:h" opt; do
	case $opt in
		u)
		    ## compulsory argument
		    ## -u <uri>
		    uri=${OPTARG}
		    #exit 0
		    ;;
		o)
		    ## optional argument
		    ## -o <output_dir>
		    output_dir=${OPTARG}
		    #exit 0
		    ;;
		h)
		    ## -h display help text
		    printf "$script_name usage: $script_usage"
		    exit 0
		    ;;
		\?)
		    printf "$script_name ${RED}invalid option: -${OPTARG}${NOC}"
		    exit 1
		    ;;
		:)
		    ## display help
		    printf "$script_name: ${RED}option -${OPTARG} requires an argument${NOC}"
		    exit 1
		    ;;
	esac
done


# playlist
if [ -n "$(echo "$uri" | grep "list=")" ]; then
    is_playlist=1
    printf "playlist detected\n"
else
    is_playlist=0
    printf "single video detected\n"
fi

## extract playlist or video id from query part of uri
if [ $is_playlist -eq 1 ]; then
    id_playlist=$(echo "$uri" | awk -F 'list=' '{print $2}' | cut -d '&' -f 1)
    printf "${GREEN}playlist ID: $id_playlist${NOC}\n"
else
    ### uri is single video
    id_video=$(echo "$uri" | awk -F '?v=' '{print $2}' | cut -d '&' -f 1)
    printf "${GREEN}video ID: $id_video${NOC}\n"
fi


# download

## set directory id slice
if [ $is_playlist -eq 0 ]; then
    id="$id_video"
elif [ $is_playlist -eq 1 ]; then
    id="$id_playlist"
fi

## make default output directory
if [ -f $HOME/clone_yt/w10_target.txt ]; then
    ### we are in a windows10 host environment
    win_env=1
    if [ -z "$output_dir" ]; then
	output_dir="$(cat $HOME/clone_yt/w10_target.txt)/"$id"/$timestamp"
    else
	printf "${RED}error: w10_target.txt not found${NOC}\n"
	printf "exiting\n"
	exit
    fi
    ### we are in a native linux environment
else
    if [ -z "$output_dir" ]; then
	output_dir="$HOME/clone_yt_data/"$id"/$timestamp"
    else
	oflag=$output_dir
	output_dir="$oflag/clone_yt_data/"$id"/$timestamp"
    fi
fi

mkdir -p "$output_dir"

## failsafe for output directory
if [ ! -d "$output_dir" ]; then
    echo
    printf "${RED}error: output directory does not exist${NOC}\n"
    printf "exiting\n"
    exit
fi

## print date time for logging
printf "date / time: `date +%Y%m%d` `date +%H%M%S`\n"

## write channel 000_video_ids
printf "writing 000_video_ids to: $output_dir\n"
printf "this can take a while, please be patient ...\n"
youtube-dl --ignore-errors --get-filename --restrict-filenames -o '%(id)s' \
	   $uri > "$output_dir"/000_video_ids
number_video_ids=$(cat "$output_dir"/000_video_ids | wc -l)
printf "$number_video_ids video id's written to $output_dir/000_video_ids\n"
echo

## download video & data \{comments}
cd "$output_dir"
youtube-dl --ignore-errors --no-overwrites --continue --write-description \
	--write-info-json --write-annotations --write-thumbnail --write-sub \
	--write-auto-sub --restrict-filenames \
	-o '%(id)s_%(title)s.%(ext)s' $uri

## download comments
cd $script_dir

## when we can't find python script
if [ ! -f "yt_comments.py" ]; then
    echo
    printf "${RED}error: yt_comments.py not found${NOC}\n"
    printf "locating ...\n"
    echo
    locate yt_comments.py
    echo
    printf "please run clone_yt.sh from original location\n"
    printf "exiting\n"
    exit
fi

## create 000_filenames
line_in_000_filenames=1
touch "$output_dir"/000_filenames
youtube-dl --ignore-errors --get-filename --restrict-filenames -o '%(id)s_%(title)s' \
	$uri >> "$output_dir"/000_filenames

while read video_id; do

	echo
	t0="`date +%s`"
	python yt_comments.py -o "$output_dir"/"$video_id".comments.json -y=$video_id

	t1="`date +%s`"
	dt=$(($t1-$t0))
	printf "\n$dt seconds\n"

	## file rename
	if [ -f "$output_dir"/"$video_id".comments.json ]; then

		filename=$(sed -n "${line_in_000_filenames}p" "$output_dir/000_filenames")
		cd "$output_dir"
		mv "$video_id".comments.json "$filename".comments.json
		printf "video $line_in_000_filenames of $number_video_ids: $filename.comment.json\n"

	fi

	## next filename
	line_in_000_filenames=$(( line_in_000_filenames + 1 ))

	cd $script_dir

done < "$output_dir"/000_video_ids

# cleanup
rm "$output_dir"/000_video_ids
mv "$output_dir"/000_filenames "$output_dir"/"$id"_000_file_names.txt

# calculate checksums
echo
hash="sha3-512"  ## md5 rmd160 sha1 sha256 sha512 sha3-512
printf "writing $hash checksums...\n"
files=$(find "$output_dir" -maxdepth 1 -type f)

for file in $files; do
	openssl dgst -$hash $file >> "$output_dir"/"$id"_000_file_"$hash"_checksums.txt
done


echo
printf "writing complete\n"
printf "${GREEN}written to: $output_dir${NOC}\n"
if [ $win_env -ne 1 ]; then
	printf "total time: $SECONDS seconds\n"
fi
echo
