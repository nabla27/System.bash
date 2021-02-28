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
C_path="\e[3`sed -n 4p $PATH_Set`m"; C_c="\e[3`sed -n 5p $PATH_Set`m"; C_mode="\e[3`sed -n 9p $PATH_Set`m"
C_sub="\e[3`sed -n 10p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"
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
		echo -e " [Are you sure to ${C_caution}delete${Cend} ${C_c}${string2}${Cend} ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			if [ -s "$terget" ]; then sed -i -e "1i `cat $PATH_pwd`" "$terget"
			else echo `cat $PATH_pwd` > "$terget"; fi
			new_name="$string2.zip"
			zip -q "${new_name}_$date" "$string2"
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
		echo -e " [Are you sure to ${C_caution}delete${Cend} ${C_c}${string2}${Cend} ?(y/n)]"
		read -n 1 _getcher
		if [ $_getcher = "y" ]; then
			touch "${terget}/.tpwd"; echo `cat $PATH_pwd` > "${terget}/.tpwd"
			new_name="${string2}.zip"
			zip -rq "${new_name}_$date" "$string2"
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
	echo -e "${C_mode}[display] > [subfield]${Cend}"
	echo "--------------------"

	number=$((terget_num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p

	echo
	echo "____________________"

	if [ -h "$terget" ]; then
		path_link=`readlink -f "$terget"`
		echo -e " ${C_c}${string2}${Cend} is a Symbolic link."
		echo -e " The path to this link is ${C_c}${path_link}${Cend}."; echo
		if [ -d "$path_link" ]; then
			echo -e " Do you want to move the path??(${C_c}y/n${Cend})"
			read -n 1 _yn
			if [ "$_yn" = y ]; then cd "$path_link" && echo `pwd` > $PATH_pwd
						mode="display" && echo "display" > $PATH_mode
						echo "→" > $PATH_file_show && exit
			else mode="display" && echo "display" > $PATH_mode && exit; fi
		elif [ -f "$path_link" ]; then
			echo " This is not directory."
			echo " Plese select the operation from \"cat\", \"less\", \"vim\", \"none\"."
			read _getcher
			if [ "$_getcher" = cat ]; then cat "$path_link"; read -n 1 _wait
			elif [ "$_getcher" = less ]; then less "$path_link"
			elif [ "$_getcher" = vim ]; then vim "$path_link"; fi
			mode="display" && echo "display" > $PATH_mode && exit
		fi
	elif [ -f "$terget" ]; then
		echo -e " ${C_c}${string2}${Cend} is a file."
		echo
		for line in `cat $PATH_list_f`
		do
			if [ "$num" -eq "$list_num2" ]; then
				echo -e " → ${C_sub}$line${Cend}"
			elif [ "$num" -ne "$list_num2" ]; then	
				echo -e "    ${C_sub}$line${Cend}"
			fi
			list_num2=$((list_num2+1))
		done
	elif [ -d "$terget" ]; then
		echo -e " ${C_c}${string2}${Cend} is a directory."
		echo
		for line in `cat $PATH_list_d`
		do
			if [ "$num" -eq "$list_num2" ]; then
				echo -e " → ${C_sub}$line${Cend}"
			elif [ "$num" -ne "$list_num2" ]; then
				echo -e "    ${C_sub}$line${Cend}"
			fi
			list_num2=$((list_num2+1))
		done
	elif [ -z "$terget" ]; then
		echo " There is no file."
		echo -e " Do you create the file??(${C_c}y/n${Cend})"
		read -n 1 _yn
		if [ $_yn = y ]; then
			echo; echo " Enter the name of new file."
			read _name
			echo; echo -e " Created ${C_c}${_name}${Cend}."; read -n 1 _wait
			touch "${_name}"; echo "→" > $PATH_file_show
			mode="display" && echo "display" > $PATH_mode; exit
		else mode="display" && echo "display" > $PATH_mode; exit; fi
	else echo -e " ${C_c}${string2}${Cend} is unknown type"; read -n 1 a; echo "display" > $PATH_mode; exit
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




