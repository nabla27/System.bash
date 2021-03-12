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
PATH_bm="$PATH_/TMP_folder/book_mark.txt"
############################################################
mode="subfield"
list_num=1
other_num=0
num=1
date=`date '+%Y-%m-%d'`
C_path="\e[3`sed -n 4p $PATH_Set`m"; C_c="\e[3`sed -n 5p $PATH_Set`m"; C_mode="\e[3`sed -n 9p $PATH_Set`m"
C_sub="\e[3`sed -n 10p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"; C_cor="\e[3`sed -n 11p $PATH_Set`m"
Cend="\e[m"
supNum=`sed -n 1p $PATH_Set`; Cor="`sed -n 12p $PATH_Set`"

#displayのnumの取得→$terget_num
IFS_BACKUP=$IFS
IFS=$'\n'
for line in `cat $PATH_file_show`
do
	case "$line" in
		*${Cor}*)
		string1=`cat $PATH_pwd`
		string2=`sed -n ${list_num}p $PATH_direct_list`
		terget="$string1/$string2"
		terget_num=$list_num
		;;
	esac
	
	list_num=$((list_num+1))
done
IFS=$IFS_BACKUP
function Other(){
	for number in {1..5}
	do
		if [ $number = $other_num ]; then space[$number]="${C_cor}${Cor}${Cend}"
		else space[$number]="  "; fi
	done
	echo -e " ${space[1]} |${C_sub}Permission${Cend}  |${comment[1]}"
	echo -e "          ${space[2]} |${C_sub}Link${Cend}        |${comment[2]}"
	echo -e "          ${space[3]} |${C_sub}Zip or Unzip${Cend}|${comment[3]}"
	echo -e "          ${space[4]} |${C_sub}Movement${Cend}    |${comment[4]}"
	echo -e "          ${space[5]} |${C_sub}Exeution${Cend}    |${comment[5]}"
}

function error_(){
	read -s -n 1; echo -e "${Cend}"
}

function _error(){
	echo -ne "${C_caution}"
}


function choices_f(){
	if [ $num -eq 1 ]; then
		xdg-open "${string2}" || less "${terget}"
	elif [ $num -eq 2 ]; then
		vim "$terget"
	elif [ $num -eq 3 ]; then
		_error; cp "$terget" "${string2}_cp" || error_
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 4 ]; then
		echo " [Enter the name of new folder]"
		read _getcher
		_error; mkdir "$_getcher" || error_
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 5 ]; then
		echo " [Enter the name of new file]"
		read _getcher
		_error; touch "$_getcher" || error_
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 6 ]; then
		echo " [Enter the new name]"
		read _getcher
		if [ "$_getcher" != "exit" ]; then _error; mv "$terget" "$_getcher" || error_; fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo -e " [Are you sure to ${C_caution}delete${Cend} ${C_c}${string2}${Cend} ?(y/n)]"
		read -s -n 1 _getcher
		if [ $_getcher = "y" ]; then
			if [ -s "$terget" ]; then _error; sed -i -e "1i `cat $PATH_pwd`" "$terget" || error_
			else echo `cat $PATH_pwd` > "$terget"; fi
			new_name="$string2.zip"
			_error; zip -q "${new_name}_$date" "$string2" || error_
			_error; mv "${new_name}_$date" $PATH_trash_f || error_
			_error; rm "$terget" || error_
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 8 ]; then
		echo
		echo -e "This is a ${C_sub}`stat --format="%F" "${terget}"`${Cend}."
		echo -e "Permission : ${C_sub}`stat --format="%A" "${terget}"`${Cend}"
		echo -e "User name  : ${C_sub}`stat --format="%U" "${terget}"`${Cend}"
		echo -e "Group name : ${C_sub}`stat --format="%G" "${terget}"`${Cend}"
		echo -e "File Size  : ${C_sub}`stat --format="%s" "${terget}"`${Cend}"
		echo -e "Device     : ${C_sub}`stat --format="%D" "${terget}"`${Cend}"
		echo -e "Node number: ${C_sub}`stat --format="%i" "${terget}"`${Cend}"
		echo -e "Hard Link  : ${C_sub}`stat --format="%h" "${terget}"`${Cend}"
		echo -e "Last access: ${C_sub}`stat --format="%x" "${terget}"`${Cend}"
		echo -e "Last Modify: ${C_sub}`stat --format="%z" "${terget}"`${Cend}"
		echo -e "Created    : ${C_sub}`stat --format="%w" "${terget}"`${Cend}"
		read -s -n 1
	elif [ $num -eq 9 ]; then Other
	fi
}
function choices_d(){
	if [ $num -eq 1 ]; then
		_error; cd "$terget" || error_
		echo `pwd` > $PATH_pwd
		mode="display" && echo "display" > $PATH_mode
		echo "${Cor}" > $PATH_file_show
	elif [ $num -eq 2 ]; then
		new_name="`echo ${string2%*/}`_cp"
		local bin=`echo ${terget%*/*}`
		echo "bin=$bin   new_name=$new_name"; read -s -n 1
		cp -r "${terget}" "${bin}/${new_name}" || read -s -n 1
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 3 ]; then
		echo " [Enter the name of new folder]"
		read _getcher
		_error; mkdir "$_getcher" || error_
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 4 ]; then
		echo " [Enter the name of new file]"
		read _getcher
		_error; touch "$_getcher" || error_
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 5 ]; then
		echo "Do you want to bookmark this path??(y/n)"
		read -s -n 1 _yn
		if [ "$_yn" = y ]; then echo "${terget}" >> $PATH_bm; fi
	elif [ $num -eq 6 ]; then
		echo " [Enter the new name]"
		read _getcher
		if [ "$_getcher" != "exit" ]; then _error; mv "$terget" "$_getcher" || error_; fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 7 ]; then
		echo -e " [Are you sure to ${C_caution}delete${Cend} ${C_c}${string2}${Cend} ?(y/n)]"
		read -s -n 1 _getcher
		if [ $_getcher = "y" ]; then
			_error; touch "${terget}/.tpwd" || error_; echo `cat $PATH_pwd` > "${terget}/.tpwd"
			new_name="${string2}.zip"
			_error; zip -rq "${new_name}_$date" "$string2" || error_
			_error; mv "${new_name}_$date" $PATH_trash_d || error_
			_error; rm -r "$terget" || error_
		fi
		mode="display" && echo "display" > $PATH_mode
	elif [ $num -eq 8 ]; then
		echo
		echo -e "This is a ${C_sub}`stat --format="%F" "${terget}"`${Cend}."
		echo -e "Permission : ${C_sub}`stat --format="%A" "${terget}"`${Cend}"
		echo -e "User name  : ${C_sub}`stat --format="%U" "${terget}"`${Cend}"
		echo -e "Group name : ${C_sub}`stat --format="%G" "${terget}"`${Cend}"
		echo -e "File Size  : ${C_sub}`stat --format="%s" "${terget}"`${Cend}"
		echo -e "Device     : ${C_sub}`stat --format="%D" "${terget}"`${Cend}"
		echo -e "Node number: ${C_sub}`stat --format="%i" "${terget}"`${Cend}"
		echo -e "Hard Link  : ${C_sub}`stat --format="%h" "${terget}"`${Cend}"
		echo -e "Last access: ${C_sub}`stat --format="%x" "${terget}"`${Cend}"
		echo -e "Last Modify: ${C_sub}`stat --format="%z" "${terget}"`${Cend}"
		echo -e "Created    : ${C_sub}`stat --format="%w" "${terget}"`${Cend}"
		read -s -n 1
	elif [ $num -eq 9 ]; then Other
	fi
}
		


while [ $mode = "subfield" ]
do
	list_num2=1
	mode=`cat $PATH_mode`

	#numの制約
	if [ $num -eq 0 ]; then num=9
	elif [ $num -eq 10 ]; then num=1; fi
	#other_numの制約
	if [ $other_num -lt 0 ]; then other_num=0
	elif [ $other_num -gt 5 ]; then other_num=5; fi
	
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

	#シンボリックリンク選択
	if [ -h "$terget" ]; then
		path_link=`readlink -f "$terget"`
		echo -e " ${C_c}${string2}${Cend} is a Symbolic link."
		echo -e " The path to this link is ${C_c}${path_link}${Cend}."
		echo    " Select the operation from the following."
		
		if [ -d "${path_link}" ]; then
		echo -e " ${C_c}[1]${Cend}move to the path ${C_c}[2]${Cend}move the link ${C_c}[3]${Cend}delete"
		read -s -n 1 _operation
			if [ $_operation -eq 1 ]; then
				_error; cd "${path_link}" || error_
				echo `pwd` > $PATH_pwd
				mode="display" && echo "display" > $PATH_mode
				echo "${Cor}" > $PATH_file_show && exit
			elif [ $_operation -eq 2 ]; then
				loop=true
				while [ $loop = true ]
				do
					echo " Enter the destination path"
					read -e _mvpath
					if [ -d "${_mvpath}" ]; then
						_error; mv "${terget}" "${_mvpath}" || error_
						loop=false
					elif [ "${_mvpath}" = exit ]; then loop=false
					else
						echo -e " ${C_caution}!! The path is incorrect !!${Cend}"
					fi
				done
				mode="display" && echo "display" > $PATH_mode
				echo "${Cor}" > $PATH_file_show && exit
			elif [ $_operation -eq 3 ]; then
				_error; rm "${terget}" || error_
				mode="display" && echo "display" > $PATH_mode
				echo "${Cor}" > $PATH_file_show && exit
			fi
		elif [ -f "${path_link}" ]; then
		echo -e " ${C_c}[1]${Cend}view the file ${C_c}[2]${Cend}move the link ${C_c}[3]${Cend}delete"
		read -s -n 1 _operation
			if [ $_operation -eq 1 ]; then
				echo -e " ${C_c}[1]${Cend}cat ${C_c}[2]${Cend}less ${C_c}[3]${Cend}vim"
				read -s -n 1 _show
				if [ $_show -eq 1 ]; then 
					_error; cat "$path_link" || error_
					read -s -n 1 _wait
					mode="display" && echo "display" > $PATH_mode
					exit
				elif [ $_show -eq 2 ]; then 
					_error; less "${path_link}" || error_
					mode="display" && echo "display" > $PATH_mode
					exit
				elif [ $_show -eq 3 ]; then 
					_error; vim "${path_link}" || error_
					mode="display" && echo "display" > $PATH_mode
					exit
				fi
			elif [ $_operation -eq 2 ]; then
				loop=true
				while [ $loop = true ]
				do
					echo " Enter the destination path"
					read -e _mvpath
					if [ -d "${_mvpath}" ]; then
						_error; mv "${terget}" "${_mvpath}" || error_
						loop=false
					elif [ "${_mvpath}" = exit ]; then loop=false
					else
						echo -e " ${C_caution}!! The path is incorrect !!${Cend}"
					fi
				done
				mode="display" && echo "display" > $PATH_mode
				echo "${Cor}" > $PATH_file_show && exit
			elif [ $_operation -eq 3 ]; then
				_error; rm "${terget}" || error_
				mode="display" && echo "display" > $PATH_mode
				echo "${Cor}" > $PATH_file_show && exit
			fi
		fi
	#通常ファイル
	elif [ -f "$terget" ]; then
		echo -e " ${C_c}${string2}${Cend} is a file."
		echo
		for line in `cat $PATH_list_f`
		do
			if [ "$num" -eq "$list_num2" ]; then
				if [ $list_num2 -eq 9 -a $other_num -gt 0 ]; then
					echo -en " ${C_cor}${Cor}${Cend} ${C_sub}$line${Cend}"
				else
					echo -e " ${C_cor}${Cor}${Cend} ${C_sub}$line${Cend}"; fi
			elif [ "$num" -ne "$list_num2" ]; then
				if [ $list_num2 -eq 9 -a $other_num -gt 0 ]; then
					echo -en "    ${C_sub}$line${Cend}"	
				else
					echo -e "    ${C_sub}$line${Cend}"; fi
			fi
			list_num2=$((list_num2+1))
		done
		if [ $other_num -gt 0 ]; then Other; fi
	#ディレクトリ
	elif [ -d "$terget" ]; then
		echo -e " ${C_c}${string2}${Cend} is a directory."
		echo
		for line in `cat $PATH_list_d`
		do
			if [ "$num" -eq "$list_num2" ]; then
				if [ $list_num2 -eq 9 -a $other_num -gt 0 ]; then
					echo -en " ${C_cor}${Cor}${Cend} ${C_sub}$line${Cend}"
				else
					echo -e " ${C_cor}${Cor}${Cend} ${C_sub}$line${Cend}"; fi
			elif [ "$num" -ne "$list_num2" ]; then
				if [ $list_num2 -eq 9 -a $other_num -gt 0 ]; then
					echo -en "    ${C_sub}$line${Cend}"
				else
					echo -e "    ${C_sub}$line${Cend}"; fi
			fi
			list_num2=$((list_num2+1))
		done
		if [ $other_num -gt 0 ]; then Other; fi
	elif [ -z "$terget" ]; then
		echo " There is no file."
		echo -e " Do you create the file??(${C_c}y/n${Cend})"
		read -s -n 1 _yn
		if [ $_yn = y ]; then
			echo; echo " Enter the name of new file."
			read _name
			echo; echo -e " Created ${C_c}${_name}${Cend}."; read -s -n 1
			_error; touch "${_name}" || error_; echo "→" > $PATH_file_show
			mode="display" && echo "display" > $PATH_mode; exit
		else mode="display" && echo "display" > $PATH_mode; exit; fi
	else echo -e " ${C_c}${string2}${Cend} is unknown type"; read -s -n 1; echo "display" > $PATH_mode; exit
	fi

	read -s -n 1 _getch
	
	case $_getch in
		w)
		if [ $other_num -gt 0 ]; then other_num=$((other_num-1))
		else num=$((num-1)); fi
		;;
		s)
		if [ $other_num -gt 0 ]; then other_num=$((other_num+1))
		else num=$((num+1)); fi
		;;
		a|q)
		if [ $other_num -gt 0 ]; then other_num=0
		else echo "display" > $PATH_mode; exit; fi
		;;
		d)
		if [ -f "$terget" -a $num -ne 9 ]; then
			choices_f
		elif [ -d "$terget" -a $num -ne 9 ]; then
			choices_d
		fi
		if [ $num -eq 9 ]; then 
			if [ $other_num -eq 0 ]; then other_num=1
			elif [ $other_num -eq 1 ]; then
				echo "> Please enter the permission. Ex)u+w Ex)755 Ex)rwxrw-rw-"
				read _operation; array_num=1
				for moji in `echo "$_operation" | fold -s1`
				do
					moji[$array_num]="$moji"
					array_num=$((array_num+1))
				done
				echo -ne "${C_caution}"
				if [ "$array_num" -eq 4 ]; then _error; chmod "$_operation" "$terget" || error_
				elif [ "$array_num" -eq 10 ]; then
					for number in {1..9}
					do
						if [ $((number%3)) -eq 1 -a "${moji[$number]}" = r ]; then pp[$number]=4
						elif [ $((number%3)) -eq 2 -a "${moji[$number]}" = w ]; then pp[$number]=2
						elif [ $((number%3)) -eq 0 -a "${moji[$number]}" = x ]; then pp[$number]=1
						elif [ "${moji[$number]}" = "-" ]; then pp[$number]=0
						else echo "The ${number}'s character is incorrect."; read -s -n 1; fi
					done
					p1=$((pp[1]+pp[2]+pp[3])); p2=$((pp[4]+pp[5]+pp[6])); p3=$((pp[7]+pp[8]+pp[9]))
					_error; chmod "${p1}${p2}${p3}" "$terget" || error_
				else echo "!! Incorrect operation !!"; read -s -n 1
				fi
			elif [ $other_num -eq 2 ]; then
				echo "> Enter a new name for a link."; read _linkname
				echo "> Which link would you like to make??"
				echo -e "    ${C_c}[1]${Cend}Hard link     ${C_c}[2]${Cend}Symbolic link"
				read -s -n 1 _operation; echo -ne "${C_caution}"
				if [ $_operation -eq 1 -a -d "$terget" ]; then _error; sudo ln -id "$terget" "$_linkname" || error_
				elif [ $_operation -eq 1 ]; then _error; ln -i "$terget" "$_linkname" || error_
				elif [ $_operation -eq 2 ]; then _error; ln -is "$terget" "$_linkname" || error_; fi
				echo -e "${Cend}"; mode="display" && echo "display" > $PATH_mode
			elif [ $other_num -eq 3 ]; then
				if [[ "$terget" = *".zip"* ]]; then
					echo "Select an operation from"
					echo -e "${C_c}[1]${Cend}Unzip    ${C_c}[2]${Cend}View details"
					read -s -n 1 _operate
					if [ $_operate -eq 1 ]; then 
						_error; unzip -q "$string2" || error_
						_error; rm -r "$string2" || error_
						mode="display" && echo "display" > $PATH_mode; exit
					elif [ $_operate -eq 2 ]; then 
						_error; unzip -l "$string2" || error_
						read -s -n 1
					fi
				else
					_error; zip -rq "${string2}.zip" "${string2}" || error_
					_error; rm -r "$string2" || error_
					mode="display" && echo "display" > $PATH_mode; exit
				fi
			elif [ $other_num -eq 4 ]; then
				roop="true"
				while [ $roop = true ]
				do
				echo "${C_c}>${Cend} Enter the destination path."
				read -e _mvpath
				if [ -d "$_mvpath" ]; then 
					_error; mv "$terget" "$_mvpath" || error_; roop="false"
					mode="display" && echo "display" > $PATH_mode; exit
				else echo -e "${C_caution}!! Not correct path !!${Cend}"; fi
				done	
			elif [ $other_num -eq 5 ]; then
				echo -e "${C_c}>${Cend} Which way do you excute??"
				echo -e " ${C_c}[1]${Cend}:bash    ${C_c}[2]${Cend}:source"
				read -s -n 1 _operation; echo; echo "________________________________________"
				if [ "$_operation" -eq 1 -o "$_operation" = bash ]; then bash "$terget"
				elif [ "$_operation" -eq 2 -o "$_operation" = source ]; then source "$terget"
				else echo -e "${C_caution}!! Not correct operation !!${Cend}"; fi
				read -s -n 1
			fi
		fi
		;;
		*)
		echo "Not an assigned key."
		;;
	esac

	perm=`ls -ld "$terget" | awk '{print $1}'`

	if [ $other_num -eq 1 ]; then
		comment[1]="Change the permission of this file."
		comment[2]="Permission of this file is ${C_c}${perm}${Cend}."
		comment[3]=""; comment[4]=""; comment[5]=""
	elif [ $other_num -eq 2 ]; then
		comment[1]="Create hard or symbolic links."
		comment[2]=""
	elif [ $other_num -eq 3 ]; then
		if [[ "$terget" = *".zip"* ]]; then
			comment[1]="This is a zip file."
			comment[2]="Unzip this file or view its details."
		else
			comment[1]="Make it a zip file."
			comment[2]=""
		fi
	elif [ $other_num -eq 4 ]; then
		comment[1]="Move the file to a different path."
		comment[2]=""
	elif [ $other_num -eq 5 ]; then
		comment[1]="Execute with the sorce or bash command."
		comment[2]=""
	fi


















done




