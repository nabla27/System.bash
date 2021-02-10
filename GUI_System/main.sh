#!/bin/bash
cd ~

PATH_mode="~/data_folder/System/GUI_System/GUI_mode"
PATH_tmpath="~/data_folder/System/GUI_System/tmp_pwd"
PATH_subfield="~/data_folder/System/Subfield_System/file_subfil

echo "menu" > ~/data_folder/System/GUI_System/GUI_mode

state="menu"

while [ "$state" != "exit" ]
do
	state=`sed -n 1p ~/data_folder/System/GUI_System/GUI_mode`

	if [ "$state" = "menu" ]; then
		bash ~/data_folder/System/File_System/file_system.sh
	elif [ "$state" = "subfield" ]; then
		cd `sed -n 1p ~/data_folder/System/GUI_System/tmp_pwd`
		bash ~/data_folder/System/Subfield_System/file_subfield.sh
	fi
done


