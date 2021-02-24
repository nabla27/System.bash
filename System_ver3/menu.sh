#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_list_menu="$PATH_/List/list_menu"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_searf="$PATH_/TMP_folder/search_file.txt"
############################################################

mode="menu"
num=1
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
	# $1:path $2:keyword

	local filepath=$1
	local key=$2

	if [ -f "$filepath" ]; then
		if [ $key != "none" ]; then
		if [[ $filepath = *"$key"* ]]; then
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
			func_search "${filepath}/${fname}" $key

		done
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
		cat $PATH_pwd
		echo
		echo "**********Command_Searching**********"
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
		echo "*************************************"

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
					echo "!! Enter the directory !!"
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
					echo "!! choose from <size>, <time>, <extension> !!"
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
				echo "------------------wating--------------------"
				func_search $path $keyword
				if [ $order = "time" ]; then
					cat $PATH_searf | sort -k 2,3V
				elif [ $order = "size" ]; then
					cat $PATH_searf | sort -k 1V
				elif [ $order = "none" ]; then
					cat $PATH_searf	
				fi
				echo "--------------------end---------------------"
				read -n 4 _exit
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
IFS=$IFS_BACKUP
