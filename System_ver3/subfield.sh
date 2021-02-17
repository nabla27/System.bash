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
PATH_trash_d="$PATH_/List/Trash_Boxd"
PATH_trash_f="$PATH_/List/Trash_Boxf"
############################################################

#cd `cat $PATH_pwd`
mode="subfield"
list_num=1
num=1
date=`date '+%Y-%m-%d'`

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

function choices_f(){
	if [ $num -eq 1 ]; then
		less $terget
	elif [ $num -eq 2 ]; then
		vim $terget
	elif [ $num -eq 3 ]; then
		cp $terget "${string2}_cp"
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 4 ]; then
		echo " [Enter the name of new folder]"
		read _getcher
		mkdir $_getcher
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 5 ]; then
		echo " [Enter the name of new file]"
		read _getcher
		touch $_getcher
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 6 ]; then
		echo " [Are you sure to delete $string2 ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			new_name="$string2.zip"
			zip -q "${new_name}_$date" $terget
			mv "${new_name}_$date" $PATH_trash_f
			rm $terget
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo
		ls -l $terget
		read -n 1 _gether
	
	fi
}
function choices_d(){
	if [ $num -eq 1 ]; then
		cd $terget && echo `pwd` > $PATH_pwd
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 2 ]; then
		new_name=`echo $string2 | sed -e "s/\//_cp/g"`
		cp -r $terget "$new_name"
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 3 ]; then
		echo " [Enter the name of new folder]"
		read _getcher
		mkdir $_getcher
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 4 ]; then
		echo " [Enter the name of new file]"
		read _getcher
		touch $_getcher
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 6 ]; then
		echo " [Are you sure to delete $string2 ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			new_name=`echo $string2 | sed -e "s/\//.zip/g"`
			zip -rq "${new_name}_$date" $terget
			mv "${new_name}_$date" $PATH_trash_d
			rm -r $terget
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo
		ls -l $terget
		read -n 1 _getcher

	fi
}
		


while [ $mode = "subfield" ]
do
	list_num2=1
	mode=`cat $PATH_mode`

	#numの制約
	if [ $num -eq 0 ]; then
		num=8
	elif [ $num -eq 9 ]; then
		num=1
	fi
	
	#描写
	clear
	cat $PATH_pwd
	echo
	echo "--------------------"

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
	elif [ -d $terget ]; then
		for line in `cat $PATH_list_d`
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
		d)
		if [ -f $terget ]; then
			choices_f
		elif [ -d $terget ]; then
			choices_d
		fi
		;;
	esac
done




