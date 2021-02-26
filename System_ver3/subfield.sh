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
PATH_Set="$PATH_/List/Setting"
############################################################
mode="subfield"
list_num=1
num=1
date=`date '+%Y-%m-%d'`
C_path=`sed -n 4p $PATH_Set`; C_c=`sed -n 5p $PATH_Set`
Cend="\e[m"
supNum=`sed -n 1p $PATH_Set`

#displayのnumの取得→$terget_num
IFS_BACKUP=$IFS
IFS=$'\n'
for line in `cat $PATH_file_show`
do
	case "$line" in
		*→*)
		string1=`cat $PATH_pwd`
		string2=`sed -n ${list_num}p $PATH_direct_list`
		terget="$string1/$string2"
		terget_num=$list_num
		;;
	esac
	
	list_num=$((list_num+1))
done
IFS=$IFS_BACKUP

function choices_f(){
	echo "$terget_num"
	if [ $num -eq 1 ]; then
		less "$terget"
	elif [ $num -eq 2 ]; then
		vim "$terget"
	elif [ $num -eq 3 ]; then
		cp "$terget" "${string2}_cp"
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
		echo " [Enter the new name]"
		read _getcher
		if [ "$_getcher" != "exit" ]; then mv "$terget" "$_getcher"; fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo " [Are you sure to delete $string2 ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			new_name="$string2.zip"
			zip -q "${new_name}_$date" "$terget"
			mv "${new_name}_$date" $PATH_trash_f
			rm "$terget"
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 8 ]; then
		echo
		ls -l "$terget"
		read -n 1 _gether
	
	fi
}
function choices_d(){
	if [ $num -eq 1 ]; then
		cd "$terget" && echo `pwd` > $PATH_pwd
		mode="display" && echo "display" > $PATH_mode
		echo "→" > $PATH_file_show
	elif [ $num -eq 2 ]; then
		new_name=`echo "$string2" | sed -e "s/\//_cp/g"`
		cp -r "$terget" "$new_name"
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
		echo " [Enter the new name]"
		read _getcher
		if [ "$_getcher" != "exit" ]; then mv "$terget" "$_getcher"; fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo " [Are you sure to delete $string2 ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			new_name=`echo $string2 | sed -e "s/\//.zip/g"`
			zip -rq "${new_name}_$date" "$terget"
			mv "${new_name}_$date" $PATH_trash_d
			rm -r "$terget"
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 8 ]; then
		echo
		ls -l "$terget"
		read -n 1 _getcher

	fi
}
		


while [ $mode = "subfield" ]
do
	list_num2=1
	mode=`cat $PATH_mode`

	#numの制約
	if [ $num -eq 0 ]; then
		num=9
	elif [ $num -eq 10 ]; then
		num=1
	fi
	
	#描写
	clear
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo "[display] > [subfield]"
	echo "--------------------"

	number=$((terget_num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p

	echo
	echo "____________________"

	if [ -f "$terget" ]; then
		echo -e "**${C_c}${string2}${Cend}** is a file."
		echo
		for line in `cat $PATH_list_f`
		do
			if [ "$num" -eq "$list_num2" ]; then
				echo " → $line"
			elif [ "$num" -ne "$list_num2" ]; then	
				echo "    $line"
			fi
			list_num2=$((list_num2+1))
		done
	elif [ -d "$terget" ]; then
		echo -e "**${C_c}${string2}${Cend}** is a directory."
		echo
		for line in `cat $PATH_list_d`
		do
			if [ "$num" -eq "$list_num2" ]; then
				echo " → $line"
			elif [ "$num" -ne "$list_num2" ]; then
				echo "    $line"
			fi
			list_num2=$((list_num2+1))
		done
	else echo -e "${C_c}${string2}${Cend} is unknown type"; read -n 1 a; echo "display" > $PATH_mode; exit
	fi

	read -n 1 _getch
	
	case $_getch in
		w)
		num=$((num-1))
		;;
		s)
		num=$((num+1))
		;;
		a|q)
		echo "display" > $PATH_mode
		exit
		;;
		d)
		if [ -f "$terget" ]; then
			choices_f
		elif [ -d "$terget" ]; then
			choices_d
		fi
		;;
		*)
		echo "Not an assigned key."
		;;
	esac
done




