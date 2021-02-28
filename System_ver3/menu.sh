#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_list_menu="$PATH_/List/list_menu"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_searf="$PATH_/TMP_folder/search_file.txt"
PATH_Set="$PATH_/List/Setting"
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
PATH_Tb_d="$PATH_/List/Trash_Boxd"
PATH_Tb_f="$PATH_/List/Trash_Boxf"
############################################################
mode="menu"
num=1
C_path="\e[3`sed -n 4p $PATH_Set`m"; C_title="\e[3`sed -n 6p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"
C_mode="\e[3`sed -n 9p $PATH_Set`m"
Cend="\e[m"

IFS_BACKUP=$IFS
IFS=$'\n'
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

function func_search(){
	IFS_BACKUP=$IFS
	IFS=$'\n'
	# $1:path $2:keyword $3:order

	local filepath=$1
	local key=$2
	local order=$3
	if [ "$order" != "none" ]; then
		if [ -f "$filepath" ]; then
			if [ "$key" != "none" ]; then
			if [[ "$filepath" = *"$key"* ]]; then
			echo `ls --time-style=long-iso -oqgh "$filepath"` | cut -f 3-6 --delim=" " >> $PATH_searf
			fi
			fi
			if [ "$key" = "none" ]; then
			echo `ls --time-style=long-iso -oqgh "$filepath"` | cut -f 3-6 --delim=" " >> $PATH_searf
			fi
		elif [ -d "$filepath" -a -r "$filepath" ]; then
			local fname
			for fname in `ls "$filepath"`
			do
				func_search "${filepath}/${fname}" "$key" $order

			done
		fi
	elif [ "$order" = "none" -a "$key" != "none" ]; then
		if [ -f "$filepath" ]; then
			if [ "$key" != "none" ]; then
			if [[ "$filepath" = *"$key"* ]]; then
			ls --time-style=long-iso -oqgh "$filepath" | cut -f 3-6 --delim=" "
			fi
			fi
			if [ "$key" = "none" ]; then
			ls --time-style=long-iso -oqgh "$filepath" | cut -f 3-6 --delim=" "
			fi
		elif [ -d "$filepath" -a -r "$filepath" ]; then
			local fname
			for fname in `ls "$filepath"`
			do
				func_search "${filepath}/${fname}" "$key" $order
			done
		fi
	elif [ "$order" = "none" -a "$key" = "none" ]; then
		ls --time-style=long-iso -oqghR "$filepath"
	fi

	IFS=$IFS_BACKUP	
}

function File_Searching(){
	point=1
	point1="→"; point2="  "; point3="  "; point4="  "; point5="  "
	path="        "
	keyword="        "
	order="        "
	while [ $point -ne -1 ]
	do
		clear
		echo -e "${C_path}`cat $PATH_pwd`${Cend}"
		echo
		echo -e "${C_mode}[display] > [menu] > [file_search]${Cend}"
		echo -e "**********${C_title}File_Searching${Cend}**********"
		echo
		echo " $point1 Path            [$path]"
		echo
		echo " $point2 Keyword         [$keyword]"
		echo
		echo " $point3 /size /time /extension [$order]"
		echo
		echo
		echo " $point4 <Clear>"
		echo " $point5 <Search>"
		echo
		echo "**********************************"

		read -n 1 _getch
		
		case $_getch in
			w)
			point=$((point-1))
			;;
			s)
			point=$((point+1))
			;;
			a|q)
			exit
			;;
			d)
			if [ $point -eq 1 ]; then
				echo " <Enter the path>"
				read _getcher
				if [ -d "$_getcher" ]; then
					path="$_getcher"
				else
					echo
					echo -e "${C_caution}!! Enter the directory !!${Cend}"
					read -n 1 warning
				fi
			elif [ $point -eq 2 ]; then
				echo " <Specify the keyword>"
				read _getcher
				keyword="$_getcher"
			elif [ $point -eq 3 ]; then
				echo " <Choose the order>"
				read _getcher
				if [ $_getcher = "size" -o $_getcher = "time" -o $_getcher = "extension" ]; then
					order="$_getcher"
				else
					echo
					echo -e "${C_caution}!! choose from <size>, <time>, <extension> !!${Cend}"
					read -n 1 warning
				fi
			elif [ $point -eq 4 ]; then
				path="        "; keyword="        "; order="        "
			elif [ $point -eq 5 ]; then
				if [ "$path" = "        " ]; then
					path=`cat $PATH_pwd`
				fi
				if [ "$keyword" = "        " -o "$keyword" = "" ]; then
					keyword="none"
				fi
				if [ "$order" = "        " ]; then
					order="none"
				fi
				rm $PATH_searf && touch $PATH_searf
				echo
				if [ "$order" != "none" ]; then
					echo -e "------------------${C_title}Searching...${Cend}--------------------"
					func_search $path $keyword $order
					echo -e "-------------------${C_title}Wating...${Cend}----------------------"
					if [ $order = "time" ]; then
						cat $PATH_searf | sort -k 2,3V
					elif [ $order = "size" ]; then
						cat $PATH_searf | sort -k 1V
					elif [ $order = "none" ]; then
						cat $PATH_searf	
					fi
					echo -e "---------------------${C_title}end${Cend}--------------------------"
					read -n 4 _exit
				elif [ "$order" = "none" ]; then
					echo -e "-------------------${C_title}Wating...${Cend}----------------------"
					func_search $path $keyword $order
					echo "---------------------${C_title}end${Cend}--------------------------"
					read -n 4 _exit
				fi
			fi	
			;;
		esac

		if [ $point -eq 0 ]; then
			point=1
		elif [ $point -eq 1 ]; then
			point1="→"; point2="  "; point3="  "; point4="  "; point5="  "
		elif [ $point -eq 2 ]; then
			point1="  "; point2="→"; point3="  "; point4="  "; point5="  "
		elif [ $point -eq 3 ]; then
			point1="  "; point2="  "; point3="→"; point4="  "; point5="  "
		elif [ $point -eq 4 ]; then
			point1="  "; point2="  "; point3="  "; point4="→"; point5="  "
		elif [  $point -eq 5 ]; then
			point1="  "; point2="  "; point3="  "; point4="  "; point5="→"
		elif [ $point -eq 6 ]; then
			point=5
		fi
	done
}

function Book_Mark(){
	echo "Book_Mark"
}

function Setting(){
local num_s=1
	while [ $num_s -ne 0 ]
	do
		clear

		#設定の反映
		for number in {1..10}
		do
			S_num[$number]="`sed -n ${number}p $PATH_Set`"
		done
		
		#カーソル位置を設定
		for number in {1..10}
		do
			if [ $num_s = $number ]; then space[$number]=" → ${number}."
			else space[$number]="    ${number}."; fi
		done
		
		echo -e "${C_path}`cat $PATH_pwd`${Cend}"
		echo
		echo -e "${C_mode}[display] > [menu] > [Setting]${Cend}"
		echo -e "*******************${C_title}Setting${Cend}********************"
		echo    "${space[1]} number of showing file.(display)          [${S_num[1]}]"
		echo -e "${space[2]} color of directory.(display)              [\e[3${S_num[2]}msample${Cend}]"
		echo -e "${space[3]} color of unknown file.(display)           [\e[3${S_num[3]}msample${Cend}]"
		echo -e "${space[4]} color of path.                            [\e[3${S_num[4]}msample${Cend}]"
		echo -e "${space[5]} Color of confirmation display.(subfield)  [\e[3${S_num[5]}msample${Cend}]"
		echo -e "${space[6]} Color of title.(menu)                     [\e[3${S_num[6]}msample${Cend}]"
		echo -e "${space[7]} Color of warning text.(menu)              [\e[3${S_num[7]}msample${Cend}]"
		echo -e "${space[8]} Color of Normal file.(display)            [\e[3${S_num[8]}msample${Cend}]"
		echo -e "${space[9]} Color of mode.                            [\e[3${S_num[9]}msample${Cend}]"
		echo -e "${space[10]} Color of subfield list.(subfield)        [\e[3${S_num[10]}msample${Cend}]" 
		
		read -n 1 _getcher
		case $_getcher in
			w)
			num_s=$((num_s-1))
			;;
			s)
			num_s=$((num_s+1))
			;;
			q)
			exit
			;;
			d)
			for number in {1..10}
			do
				if [ $num_s -eq $number ]; then S_num[$number]=$((S_num[number]+1)); fi
			done
			;;
			a)
			for number in {1..10}
			do
				if [ $num_s -eq $number ]; then S_num[$number]=$((S_num[number]-1)); fi
			done
			;;
		esac

		#各パラメータの制約
		for number in {2..10}
		do
			if [ ${S_num[$number]} -eq 8 ]; then S_num[$number]=7
			elif [ ${S_num[$number]} -lt 1 ]; then S_num[$number]=1; fi
		done
		if [ $num_s -eq 11 ]; then num_s=10
		elif [ $num_s -eq 0 ]; then num_s=1; fi
		if [ ${S_num[1]} -eq 3 ]; then S_num[1]=4; fi

		
		
		#Settingファイルへの書き込み
		rm $PATH_Set && touch $PATH_Set
		for number in {1..10}
		do
			echo ${S_num[$number]} >> $PATH_Set
			
		done


	done

}

function Directory_hist(){
	local list_sup=`cat $PATH_tpwd | wc -l`
	echo $list_sup
	if [ $list_sup -eq 0 ]; then
		echo
		echo -e "${C_caution}!! There is no directory history !!${Cend}"
		read -n 1 _wait
	fi
	while [ $list_sup -ne 0 ]
	do
		clear
		local list_num=1
		echo -e "${C_path}`cat $PATH_pwd`${Cend}"
		echo
		echo -e "${C_mode}[display] > [menu] > [Directory_hist]${Cend}"
		echo -e "********************${C_title}Directory_hist${Cend}********************"
		while [ $list_num -le $list_sup ]
		do
			echo " ${list_num}. `sed -n ${list_num}p $PATH_tpwd`"
			list_num=$((list_num+1))
		done

		read _getcher
		case $_getcher in
			[1-9]|[1-9][0-9])
			if [ $_getcher -le $list_sup ]; then
				#cat "$PATH_pwd" >> $PATH_tpwd
				echo `sed -n ${_getcher}p $PATH_tpwd` > $PATH_pwd
				exit
			else echo -e "${C_caution}!! This is an unassigned number !!${Cend}"
			read -n 1 _wait
			fi
			;;
			q|exit)
			exit
			;;
		esac
		echo
		echo " You can move it by enterning a number."
	done
}

function Trash_Box(){
local num_=1
while [ $num_ != 0 ]
do
	num_=1
	clear
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display] > [menu] > [Trash_Box]${Cend}"
	echo -e "********************${C_title}directory${Cend}********************"
	for line in `ls -1 $PATH_Tb_d`
	do
		echo -e "${C_title}${num_}${Cend}. ${line}"
		num_=$((num_+1))
	done
	echo -e "********************${C_title}file${Cend}********************"
	for line in `ls -1 $PATH_Tb_f`
	do
		echo -e "${C_title}${num_}${Cend}. ${line}"
		num_=$((num_+1))
	done
	echo "****************************************************************"
	echo -e "> ${C_title}Enter the number.${Cend}  Ex) 3  Ex) 2,3,4  Ex) 2-10"
	read _number
	if [ "$_number" = a -o "$_number" = q -o "$_number" = "exit" ]; then exit; fi
	if [[ "$_number" = *","* ]]; then
		local field_sup=`echo "$_number" | awk -F, '{print NF}'`
		local bound=`ls -1 $PATH_Tb_d | wc -l`
		local array_num=1
		while [ $array_num -le $field_sup ]
		do
			cut_num=`echo "$_number" | awk -v "fn=${array_num}" -F, '{print $fn}'`
			if [ $cut_num -le $bound ]; then
				file_name[$array_num]="`ls -1 $PATH_Tb_d | sed -n ${cut_num}p`"
			elif [ $cut_num -gt $bound ]; then
				local cutting_num=$((cut_num-bound))
				file_name[$array_num]="`ls -1 $PATH_Tb_f | sed -n ${cutting_num}p`"
			fi
			array_num=$((array_num+1))
		done
		array_num=1
		while [ $array_num -le $field_sup ]
		do
			echo -e " ${C_title}${file_name[array_num]}${Cend}"
			array_num=$((array_num+1))
		done
		echo "> Select the operation for the above file from the following."
		echo -e "  ${C_title}[1]${Cend}:Complete deletion   or   ${C_title}[2]${Cend}:Unzip   or   ${C_title}[3]${Cend}:Detail view"
		read -n 1 _operation
		array_num=1; echo
		echo "****************************************************************"
		while [ $array_num -le $field_sup ]
		do
			if [ "$_operation" -eq 1 ]; then
				if [ -e "${PATH_Tb_d}/${file_name[array_num]}" ]; then
					rm "${PATH_Tb_d}/${file_name[array_num]}"
				elif [ -e "${PATH_Tb_f}/${file_name[array_num]}" ]; then
					rm "${PATH_Tb_f}/${file_name[array_num]}"; fi
			elif [ "$_operation" -eq 2 ]; then
				if [ -e "${PATH_Tb_d}/${file_name[array_num]}" ]; then
					cd $PATH_Tb_d
					unzip -q "${PATH_Tb_d}/${file_name[array_num]}"
					name_=`echo ${file_name[array_num]} | awk -F '.zip' '{print $(NF-1)}'`
					mv_path=`cat ${name_}/.tpwd`
					echo -e "The original path for ${C_title}${name_}${Cend} is ${C_title}${mv_path}${Cend}."
					rm "${name_}/.tpwd" && rm ${file_name[array_num]}
					if [ -d "$mv_path" ]; then mv ${name_} "$mv_path"
					else
						echo " The file has been moved to home directory."
						mv ${name_} ~
					fi
					cd `cat $PATH_pwd`
				elif [ -e "${PATH_Tb_f}/${file_name[array_num]}" ]; then
					cd $PATH_Tb_f
					unzip -q "${PATH_Tb_f}/${file_name[array_num]}"
					name_=`echo ${file_name[array_num]} | awk -F '.zip' '{print $(NF-1)}'`
					mv_path=`cat ${name_} | sed -n 1p`
					echo -e "The original path for ${C_title}${name_}${Cend} is ${C_title}${mv_path}${Cend}."
					sed -i -e 1d ${name_} && rm ${file_name[array_num]}
					if [ -d "$mv_path" ]; then mv ${name_} "$mv_path"
					else 
						echo " The file has been moved to home directory."
						mv ${name_} ~
					fi
					cd `cat $PATH_pwd`
				fi
			elif [ "$_operation" -eq 3 ]; then
				if [ -e "${PATH_Tb_d}/${file_name[array_num]}" ]; then
					cd "$PATH_Tb_d"
					local int=1
					for line in `unzip -l "${file_name[array_num]}"`
					do
						if [ $int -eq 1 ]; then echo -e "${C_title}${line}${Cend}"
						else echo "$line"; fi
						int=$((int+1))
					done
					cd `cat $PATH_pwd`
				elif [ -e "${PATH_Tb_f}/${file_name[array_num]}" ]; then
					cd "$PATH_Tb_f"
					local int=1
					for line in `unzip -l "${file_name[array_num]}"`
					do
						if [ $int -eq 1 ]; then echo -e "${C_title}${line}${Cend}"
						else echo "$line"; fi
						int=$((int+1))
					done
					cd `cat $PATH_pwd`
				fi
			fi
			array_num=$((array_num+1))
		done
	elif [[ "$_number" = *"-"* ]]; then
		echo "bar"
	elif [ "$_number" -ge "$num_" ]; then echo -e "${C_caution}!! Incorrect number !!${Cend}"
	elif expr "$_number" : "[0-9]*$" >&/dev/null; then
		echo "number"
	else echo -e "${C_caution}!! The key is incorrect !!${Cend}"
	fi
	read -n 1 a
done
}

clear
while [ $mode = "menu" ]
do
	#numの制約
	if [ $num -eq 0 ]; then
		num=6
	elif [ $num -eq 7 ]; then
		num=1
	fi

	#描写
	clear
	mode=`cat $PATH_mode`
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display] > [menu]${Cend}"
	echo -e "**********${C_title}MENU${Cend}**********"

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
		elif [ $num -eq 4 ]; then
			Setting
		elif [ $num -eq 5 ]; then
			Directory_hist
		elif [ $num -eq 6 ]; then
			Trash_Box
		fi


	esac
	













done
IFS=$IFS_BACKUP
