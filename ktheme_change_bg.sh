#!/bin/bash

##########################################################################################
#
# Change background image for Kakaotalk Theme (.ktheme)
# 
# iolate <iolate@me.com>
# 2017. 01. 16.
# 
# ------------------------------------------
# Min's iOS Theme - http://min0628.com/
# Background color - #c4c4c4
# 
##########################################################################################

how_to() {
	echo "[Usage]"
	echo "$ $0 /path/to/theme.ktheme"
	echo
}

exitfn() {
	trap SIGINT
	echo;
	
	# Remove files
	if [ -f "./KakaoTalk.css" ]; then
		rm ./KakaoTalk.css
	fi
	
	if [ -d "./Images" ]; then
		if [ -f "./Images/chatroom_bg@2x.png" ]; then
			rm ./Images/chatroom_bg@2x.png
		fi
		if [ ! "$(ls -A ./Images)" ]; then
			rm -r ./Images
		fi
	fi
	
	exit
}

if [ ! "$1" ] || [ ! -f "$1" ]; then
	echo "Invalid arguments."; echo
	how_to
	exit 1
fi

if [ -f "./KakaoTalk.css" ] || [ -f "./Images/chatroom_bg@2x.png" ]; then
	echo; echo "There are files that can be conflicted."
	echo " ./KakaoTalk.css"
	echo " ./Images/chatroom_bg@2x.png"
	echo "Please remove them or change path and try again."
	exit 1
fi

NEW_FILE="${1%.*}_BG.ktheme"
if [ -f "$NEW_FILE" ]; then
	echo; echo "Output file will be named \"$NEW_FILE\" but already existed!"
	echo "Please remove it or change path and try again."
	exit 1
fi

trap "exitfn" INT

echo; echo "[1] Extract background image."
# Extract background image
if [ ! -d "./Images" ]; then
	mkdir "./Images"
fi

TEMP_BG="./Images/chatroom_bg@2x.png"
unzip -p "$1" "Images/chatroom_bg@2x.png" > "$TEMP_BG"

open "./Images"
echo "Background image was extracted."
echo "Background color - #c4c4c4"
read -p "Modify this file and press any key to continue..."

echo; echo "[2] Copy .ktheme"
# Copy ktheme
cp "$1" "$NEW_FILE"

echo; echo "[3] Update background image"
# Update background image
zip -u "$NEW_FILE" "$TEMP_BG"

echo; echo "[4] Change theme name (add suffix 'BG')"
# Change theme name
TEMP_CSS="./KakaoTalk.css"
unzip -p "$NEW_FILE" KakaoTalk.css | sed "s/-kakaotalk-theme-name: url('\(.*\)');/-kakaotalk-theme-name: url('\1 BG');/g" > "$TEMP_CSS"
zip -u "$NEW_FILE" "$TEMP_CSS"

# Finish
echo; echo "Completed!"
echo "$NEW_FILE"
echo

trap SIGINT
exitfn
