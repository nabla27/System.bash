#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_direct_list="$PATH_/TMP_folder/direct_list.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_list_f="$PATH_/List/list_f"
PATH_list_d="$PATH_/List/list_d"
############################################################


mode="subfield"
list_num=1
num=1

for line in `cat $PATH_file_show`
do
	case $line in
		*→*)
		string1=`cat $PATH_pwd`
		string2=`sed -n ${list_num}p $PATH_direct_list`
		terget="$string1/$string2"
		terget_num=$list_num
		;;
	esac
	
	list_num=$((list_num+1))
done	


while [ $mode = "subfield" ]
do
	clear
	list_num2=1
	mode=`cat $PATH_mode`

	cat $PATH_pwd
	echo

	if [ "$terget_num" -le "10" ]; then
		cat $PATH_file_show | head -n 10
	elif [ "$terget_num" -gt "10" ]; then
		cat $PATH_file_show | sed -n '10,20p'
	fi

	echo
	echo "____________________"

	if [ -f $terget ]; then
		for line in `cat $PATH_list_f`
		do
			if [ "$num" -eq "$list_num2" ]; then
				echo " → $line"
			elif [ "$num" -ne "$list_num2" ]; then	
				echo "    $line"
			fi
			list_num2=$((list_num2+1))
		done
	fi

	read -n 1 _getch
	
	case $_getch in
		w)
		num=$((num-1))
		;;
		s)
		num=$((num+1))
		;;
		a)
		echo "display" > $PATH_mode
		exit
		;;
	esac
done

















done
