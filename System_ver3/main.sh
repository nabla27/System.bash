#!/bin/bash
################################################################################
#It is necessary to set the following path to "System_ver3" exists.
PATH_="/home/nabla27/data_folder/System.bash/System_ver3"
################################################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_disp="$PATH_/display.sh"
PATH_subfield="$PATH_/subfield.sh"
PATH_menu="$PATH_/menu.sh"
PATH_cmd="$PATH_/Command_Line.sh"
PATH_sf="$PATH_/file_search.sh"
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
################################################################################
cd $PATH_ && echo $PATH_ > $PATH_pwd
################################################################################
sed -i -e 3d display.sh && sed -i -e "3i PATH_=\"${PATH_}\"" display.sh
sed -i -e 3d subfield.sh && sed -i -e "3i PATH_=\"${PATH_}\"" subfield.sh
sed -i -e 3d menu.sh && sed -i -e "3i PATH_=\"${PATH_}\"" menu.sh
sed -i -e 3d file_search.sh && sed -i -e "3i PATH_=\"${PATH_}\"" file_search.sh
################################################################################
cd ~ && echo `pwd` > $PATH_pwd
clear
rm $PATH_tpwd && touch $PATH_tpwd
echo "display" > $PATH_mode
mode="display"
echo "→" > $PATH_file_show

while [ $mode != "exit" ]
do
	IFS_BACKUP=$IFS
	IFS=$'\n'
	mode=`cat $PATH_mode`

	if [ $mode = "display" ]; then
		cd `cat $PATH_pwd`
		bash $PATH_disp
	elif [ $mode = "subfield" ]; then
		cd `cat $PATH_pwd`
		bash $PATH_subfield
	elif [ $mode = "menu" ]; then
		cd `cat $PATH_pwd`
		bash $PATH_menu
	elif [ $mode = "Command_Line" ]; then
		cd `cat $PATH_pwd`
		bash $PATH_cmd
	elif [ $mode = "search_file" ]; then
		cd `cat $PATH_pwd`
		bash $PATH_sf
	fi
	IFS=$IFS_BACKUP
done

	
