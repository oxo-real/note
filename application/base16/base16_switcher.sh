#! /usr/bin/env sh

# loop through base16-shell themes

all_themes=$(alias | grep '^base16_' | sed 's/^[^"]\+"\([^"]\+\)".*$/\1/')
while read theme; do echo "$theme"; [[ -n "$theme" ]] && "$theme"; sleep 2; done <<< "$all_themes"
#for theme in "$all_themes"; do echo "$theme"; [[ -n "$theme" ]] && "$theme"; sleep 2; done

#all_themes=$(alias | grep "^base16_" | sed 's/^[^"]\+"\([^"]\+\)".*$/\1/')
#ex_light_themes=$(echo "$all_themes" | tr " " "\n" | grep -v "\-light")
#for theme in "$all_themes"; do sleep 2; echo "$theme"; sh "$theme"; done
