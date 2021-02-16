#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_disp="$PATH_/display.sh"
PATH_subfield="$PATH_/subfield.sh"
############################################################
clear
echo "display" > $PATH_mode
mode="display"

while [ $mode != "exit" ]
do
	mode=`cat $PATH_mode`

	if [ $mode = "display" ]; then
		bash $PATH_disp
	elif [ $mode = "subfield" ]; then
		bash $PATH_subfield
	fi
done

	
