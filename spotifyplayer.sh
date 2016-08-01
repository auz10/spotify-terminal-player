#!/bin/bash

unhide_cursor() {
    printf '\e[?25h'
}
trap unhide_cursor EXIT

printf '\e[?25l'
clear 
while true ; do

    printf '\033[;H'
    
    width=$(tput cols)
    height=$(tput lines)
    song=$(osascript -e 'tell application "Spotify" to set trackname to name of current track')
    artist=$(osascript -e 'tell application "Spotify" to set artistname to artist of current track')
    album=$(osascript -e 'tell application "Spotify" to set albumname to album of current track')
    tracker=$(osascript -e 'tell application "Spotify" to return player position')
    duration=$(osascript -e 'tell application "Spotify" to set dur to duration of current track')
    state=$(osascript -e 'tell application "Spotify" to set state to player state')
    
    str="Width = $width Height = $height"
    tracker2="10#"${tracker//.}
    length=${#str}

    if [ $tracker2 == $duration ]; then clear; fi
    if [[ $percent == "100" ]]; then clear; fi
    if [[ $percent == "0" ]]; then clear; fi

    if [[ $duration > "0" ]]; then percent=$((100*$tracker2/$duration)); fi
    
    tput cup $((height / 2 - 4)) $(((width / 2) - (length / 2) - 17))
    tput setaf 160; tput smul; echo "Spotify Player                                 $playingstate"; tput sgr0
    tput cup $((height / 2 - 2)) $(((width / 2) - (length / 2) - 17))
    tput setaf 202; echo "Song:$(tput setaf 226) $song                          "; tput sgr0
    tput cup $((height / 2 - 1)) $(((width / 2) - (length / 2) - 17))
    tput setaf 202; echo "Artist:$(tput setaf 226) $artist                           "; tput sgr0
    tput cup $((height / 2 )) $(((width / 2) - (length / 2) - 17))
    tput setaf 202; echo "Album:$(tput setaf 226) $album                             "; tput sgr0
    tput cup $((height / 2 + 1)) $(((width / 2) - (length / 2) - 17))
    d=$(printf "%-50s" "-")
    tput setaf 160; echo "${d// /-}"; tput sgr0 
    tput cup $((height / 2 + 2)) $(((width / 2) - (length / 2) - 17))
    s=$(printf "%-$((percent / 2))s" "▒")
    tput setaf 202; tput setab 202; echo "${s// /▒}"; tput sgr0 
    tput cup $((height / 2 + 3)) $(((width / 2) - (length / 2) - 17))
    d=$(printf "%-50s" "-")
    tput setaf 160; echo "${d// /-}"; tput sgr0 

    tput cup $((height / 2 + 4)) $(((width / 2) - (length / 2) - 17))
    tput setaf 226; if [ $state == "playing" ]; then echo "$percent"; playingstate="▶ "; else playingstate="▮▮"; fi
    tput sgr0

    sleep 0.5

done