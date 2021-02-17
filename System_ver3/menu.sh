#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_list_menu="$PATH_/List/list_menu"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
############################################################

mode="menu"
num=1

function output(){
	list_num=1
	for line in `cat $PATH_list_menu`
	do
		if [ "$num" -eq $list_num ]; then
			echo " → $line"
		elif [ "$num" -ne $list_num ]; then
			echo "    $line"
		fi
		list_num=$((list_num+1))
	done
}

function Command_Searching(){
	echo "Command_Searching"
}
function File_Searching(){
	echo "File_Searchig"
}
function Book_Mark(){
	echo "Book_Mark"
}



clear
while [ $mode = "menu" ]
do
	#numの制約
	if [ $num -eq 0 ]; then
		num=4
	elif [ $num -eq 5 ]; then
		num=1
	fi

	#描写
	clear
	mode=`cat $PATH_mode`
	cat $PATH_pwd
	echo
	echo "**********MENU**********"

	output

	#パラメータ変化
	read -n 1 _getch
	
	case $_getch in
		w)
		num=$((num-1))
		;;
		s)
		num=$((num+1))
		;;
		a|q)
		mode="display" && echo "display" > $PATH_mode
		exit
		;;
		d)
		if [ $num -eq 1 ]; then
			Command_Searching
		elif [ $num -eq 2 ]; then
			File_Searching
		elif [ $num -eq 3 ]; then
			Book_Mark
		fi


	esac
	













done

