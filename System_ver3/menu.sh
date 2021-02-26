#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_list_menu="$PATH_/List/list_menu"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_searf="$PATH_/TMP_folder/search_file.txt"
PATH_Set="$PATH_/List/Setting"
############################################################
mode="menu"
num=1
C_path=`sed -n 4p $PATH_Set`; C_title=`sed -n 6p $PATH_Set`; C_caution=`sed -n 7p $PATH_Set`
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
		echo "[display] > [menu] > [file_search]"
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
					echo -e "-------------------${C_title}Wating...${C_end}----------------------"
					func_search $path $keyword $order
					echo "---------------------end--------------------------"
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
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo "[display] > [menu]"
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
		fi


	esac
	













done
IFS=$IFS_BACKUP
