#!/bin/bash


clear
num=1
file_num=`sed -n 2p ~/data_folder/System/File_System/memory_File_System`


function func(){
	if [ -d `sed -n 1p ~/data_folder/System/File_System/memory_File_System` ]; then
		if [ "$num" -eq 1 ]; then
			cd `sed -n 1p ~/data_folder/System/File_System/memory_File_System`
			echo "menu" > ~/data_folder/System/GUI_System/GUI_mode
			sed -n 1p ~/data_folder/System/File_System/memory_File_System > ~/data_folder/System/GUI_System/tmp_pwd
			sed -i '2d' ~/data_folder/System/File_System/memory_File_System
		   	echo "1" >> ~/data_folder/System/File_System/memory_File_System	
			exit
		elif [ "$num" -eq 2 ]; then
			echo
		elif [ "$num" -eq 3 ]; then
			echo "作成するディレクトリ名を入力してください。(キャンセル:C)"
			read name
			if [ "$name" != "C" ]; then
				mkdir "$name"
			fi
		elif [ "$num" -eq 4 ]; then
			echo
		elif [ "$num" -eq 5 ]; then
			echo
		elif [ "$num" -eq 6 ]; then
			echo
		elif [ "$num" -eq 7 ]; then
			echo
		fi
	else
		if [ "$num" -eq 1 ]; then
			less `sed -n 1p ~/data_folder/System/File_System/memory_File_System`
		elif [ "$num" -eq 2 ]; then
			vim `sed -n 1p ~/data_folder/System/File_System/memory_File_System`
		elif [ "$num" -eq 3 ]; then
			echo
		elif [ "$num" -eq 4 ]; then
			echo
		elif [ "$num" -eq 5 ]; then
			echo
		elif [ "$num" -eq 6 ]; then
			echo
		elif [ "$num" -eq 7 ]; then
			echo
		elif [ "$num" -eq 8 ]; then
			echo
		fi
	fi
}









while [ "$num" -gt "0" ]
do
	echo `pwd`
	echo
	if [ "$file_num" -le "10" ]; then
		cat ~/data_folder/System/File_System/file_system.txt | head -n 10
	elif [ "$file_num" -gt "10" ]; then
		cat ~/data_folder/System/File_System/file_system.txt | sed -n '10,20p'
	fi

	list_num=1
	echo "____________________________"

	if [ -d `sed -n 1p ~/data_folder/System/File_System/memory_File_System` ]; then
		for line in `cat ~/data_folder/System/Subfield_System/field_list_d`
		do
			if [ "$num" -eq "$list_num" ]; then
				echo "| → $line"
			elif [ "$num" -ne "$list_num" ]; then
				echo "|    $line"
			fi
			list_num=$((list_num+1))
		done
	else
		for line in `cat ~/data_folder/System/Subfield_System/field_list_f`
		do
			if [ "$num" -eq "$list_num" ]; then
				echo "| → $line"
			elif [ "$num" -ne "$list_num" ]; then
				echo "|    $line"
			fi
			list_num=$((list_num+1))
		done
	fi

	echo "￣￣￣￣￣￣￣￣￣￣￣￣￣￣"

	read -n 1 _getch
	case "$_getch" in
		w)
		num=$((num-1))
		;;
		s)
		num=$((num+1))
		;;
		a|q)
		echo "menu" > ~/data_folder/System/GUI_System/GUI_mode
		exit
		;;
		d)
		func
		;;
	esac
	clear
done

