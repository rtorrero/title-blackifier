#!/bin/bash

if [ $# -ne 2 ]; then
	echo "$0: usage: title-blackifier.sh <search string> <command>"
	exit 1
fi

search_string=$1
command=$2

echo "about to run command"
nohup $command >/dev/null&
echo "Polling wmctrl for window id..."

# Find all target window IDs and save them to a variable
instances=$(wmctrl -l | grep $search_string | cut -d" " -f1 | wc -l)
while [ $instances -le 0 ]
do
	sleep 0.1
	instances=$(wmctrl -l | grep $search_string | cut -d" " -f1 | wc -l)
done

windowIds=$(wmctrl -l | grep $search_string | cut -d" " -f1)
echo "Target found, proceed..."

echo $windowIds

# Loop and set all windows to GTK dark variant
while read -r line; do
	xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark" -id $line
done <<< $windowIds
