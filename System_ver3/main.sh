#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_disp="$PATH_/display.sh"
PATH_subfield="$PATH_/subfield.sh"
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
############################################################
clear
rm $PATH_tpwd && touch $PATH_tpwd
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

	
