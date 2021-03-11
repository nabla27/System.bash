#!/bin/bash
###########################################################
PATH_="/home/nabla27/data_folder/System.bash/System_ver3"
###########################################################
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_searf="$PATH_/TMP_folder/search_file.txt"
PATH_Set="$PATH_/List/Setting"
PATH_show_sf="$PATH_/TMP_folder/show_sf.txt"
###########################################################
C_path="\e[3`sed -n 4p $PATH_Set`m"; C_title="\e[3`sed -n 6p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"
C_mode="\e[3`sed -n 9p $PATH_Set`m"; C_cor="\e[3`sed -n 11p $PATH_Set`m"; C_c="\e[3`sed -n 5p $PATH_Set`m"
Cor="`sed -n 12p $PATH_Set`"
Cend="\e[m"

mode="search_file"
prin[1]="${C_cor}${Cor}${Cend}"; prin[2]="  "; prin[3]="  "; prin[4]="  "; prin[5]="  "; prin[6]="  "; prin[7]="  "; prin[8]="  "; prin[9]="  "
ppath="none"; kkeyword1="none"; kkeyword2="none"; exkeyword="none"; oorder="none"; condition="and"
num=1

IFS_BACKUP=$IFS
IFS=$'\n'



function search(){
	local path="$1"
	local keyword1="$2"
	local keyword2="$3"
	local condition="$4"
	local exkeyword="$5"

	if [ $count -gt $((block*num_show)) -a $num_show -le 100 -a $num_file -ge 100 ]; then
		echo -ne "${C_title}/${Cend}"
		num_show=$((num_show+1))
	fi

	if [ -f "${path}" -o -h "${path}" ]; then
		function exsearf(){
		if [ "${keyword1}" = "none" ]; then
			echo `ls --time-style=long-iso -oqg "${path}"` | cut -f 3-10 --delim=" " >> $PATH_searf
		elif [ "${keyword1}" != "none" -a "${keyword2}" = "none" ]; then
			if [[ "${path}" = *"${keyword1}"* ]]; then
				echo `ls --time-style=long-iso -oqg "${path}"` | cut -f 3-10 --delim=" " >> $PATH_searf
			fi			else
			if [ "${condition}" = "and" ]; then	
				if [[ "${path}" = *"${keyword1}"* ]]; then
					if [[ "${path}" = *"${keyword2}"* ]]; then
						echo `ls --time-style=long-iso -oqg "${path}"` | cut -f 3-10 --delim=" " >> $PATH_searf
					fi
				fi
			elif [ "${condition}" = "or" ]; then
				if [[ "${path}" = *"${keyword1}"* ]]; then
					echo `ls --time-style=long-iso -oqg "${path}"` | cut -f 3-10 --delim=" " >> $PATH_searf
				elif [[ "${path}" = *"${keyword2}"* ]]; then
					echo `ls --time-style=long-iso -oqg "${path}"` | cut -f 3-10 --delim=" " >> $PATH_searf
				fi
			fi
		fi
		}

		if [ "${exkeyword}" = "none" ]; then
			exsearf
		elif [ "${exkeyword}" != "none" ]; then
			if [[ "${path}" != *"${exkeyword}"* ]]; then
				exsearf
			fi
		fi
		count=$((count+1))
	elif [ -d "${path}" ]; then
		local fname
		for fname in `ls "${path}" 2>/dev/null` 
		do
			search "${path}/${fname}" "${keyword1}" "${keyword2}" "${condition}" "${exkeyword}"
		done
	fi
}



while [ "$mode" = "search_file" ]
do
#mode=`cat $PATH_mode`
	clear
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display] > [menu] > [File_Searching]${Cend}"
	echo -e "*************${C_title}File_Searching${Cend}***************"
	echo -e "${prin[1]} path                       ["${ppath}"]"
	echo -e "${prin[2]} keyword1                   ["${kkeyword1}"]"
	echo -e "${prin[3]} keyword2                   ["${kkeyword2}"]"
	echo -e "${prin[4]} keyword connection         ["${condition}"]"
	echo -e "${prin[5]} exclude keyword            ["${exkeyword}"]"
	echo -e "${prin[6]} order                      ["${oorder}"]"
	echo
	echo -e "${prin[7]} Clear"
	echo -e "${prin[8]} Search"
	echo -e "${prin[9]} view with less"
	echo "******************************************"
	
	read -s -n 1 _getch

	case $_getch in 
	w)
	num=$((num-1))
	;;
	s)
	num=$((num+1))
	;;
	q|a)
	mode="menu" && echo "menu" > $PATH_mode; exit
	;;
	"[")
	num=1
	;;
	"]")
	num=8
	;;
	d)
	if [ $num -eq 1 ]; then
		loop="true"
		while [ "${loop}" = "true" ]
		do
			echo "> Enter the path for searching."
			read -e _getcher
			if [ -d "${_getcher}" ]; then ppath="${_getcher}"; loop="false"
			elif [ "${_getcher}" = "exit" -o "${_getcher}" = "none" ]; then ppath="none"; loop="false"
			else echo -e "${C_caution}!! Not exits the path !!${Cend}"; fi
		done
	elif [ $num -eq 2 ]; then
		echo "> Enter the keyword1."
		read _getcher
		if [ "${_getcher}" = "none" ]; then kkeyword2="none"; fi
		kkeyword1="${_getcher}"
	elif [ $num -eq 3 ]; then
		if [ "${kkeyword1}" != "none" ]; then
			echo "> Enter the keyword2."
			read _getcher
			kkeyword2="${_getcher}"
		else
			echo; echo -e "${C_caution}!! Enter the keyword1 first !!${Cend}"; read -n 1 _wait
		fi
	elif [ $num -eq 4 ]; then
		if [ "${condition}" = "and" ]; then condition="or"
		elif [ "${condition}" = "or" ]; then condition="and"; fi
	elif [ $num -eq 5 ]; then
		echo "> enter the keyword for excludeing."
		read _getcher
		exkeyword="${_getcher}"
	elif [ $num -eq 6 ]; then
		echo "> Select the order from \"time\" or \"size\"."
		read _getcher
		oorder="${_getcher}"
	elif [ $num -eq 7 ]; then
		ppath="none"; kkeyword1="none"; kkeyword2="none"; exkeyword="none"; oorder="none"; condition="and"
	elif [ $num -eq 8 ]; then
		rm $PATH_searf && touch $PATH_searf
		echo; echo -e "****************${C_title}waiting${Cend}*******************"
		if [ "${ppath}" = "none" ]; then ppath=`cat $PATH_pwd`; fi
		num_file=`ls -pR -U1 "${ppath}" | grep -v -e / -e '^\s*$' | wc -l`
		block=$((num_file/100))
		if [ $num_file -ge 100 ]; then
			echo "|_________1_________2_________3_________4_________5_________6_________7_________8_________9_________|${num_file}"; fi
		count=0; num_show=1; sum_file=0; sum_size=0
		search "${ppath}" "${kkeyword1}" "${kkeyword2}" "${condition}" "${exkeyword}"
		
		echo
		echo         "----------------------------------------------------------------------------------------------------"
		#######################################################
		sum_file=`cat $PATH_searf | wc -l`
		for size_b in `cut -f 1 --delim=" " "$PATH_searf"`
		do
			sum_size=$((sum_size+size_b))
		done
		if [ $((sum_size/(1024**3))) -ne 0 ]; then
			show_size="$((sum_size/(1024**3)))GB"
		elif [ $((sum_size/(1024**2))) -ne 0 ]; then
			show_size="$((sum_size/(1024**2)))MB"
		elif [ $((sum_size/(1024**1))) -ne 0 ]; then
			show_size="$((sum_size/1024))KB"
		else
			show_size="${sum_size}B"
		fi
		#######################################################
		if [ "${oorder}" = time ]; then 
			sort -k 2,3V $PATH_searf > $PATH_show_sf
			cat $PATH_show_sf
		elif [ "${oorder}" = size ]; then 
			sort -k 1V $PATH_searf > $PATH_show_sf
			cat $PATH_show_sf
		elif [ "${oorder}" = none ]; then cat $PATH_searf > $PATH_show_sf; cat $PATH_searf
		else 
			echo -e "${C_caution}!! order is not correct !!${Cend}"; read -s -n 1
			cat $PATH_searf; fi
		echo         "----------------------------------------------------------------------------------------------------"
		echo -e "The total number of files is ${C_c}${sum_file}${Cend}. The total is ${C_c}${sum_size}${Cend} bytes. (${C_c}${show_size}${Cend})"
		echo         "----------------------------------------------------------------------------------------------------"
		read -s -n 1
	elif [ $num -eq 9 ]; then
		echo "> Select the display method"
		echo -e "  ${C_c}[1]${Cend}${oorder}(less)    ${C_c}[2]${Cend}none(less)    ${C_c}[3]${Cend}${oorder}(cat)"
		read -s -n 1 _choice
		if [ $_choice -eq 1 ]; then less $PATH_show_sf
		elif [ $_choice -eq 2 ]; then less $PATH_searf
		elif [ $_choice -eq 3 ]; then cat $PATH_show_sf; read -s -n 1
		fi
	fi
	;;
	esac

	#numの制約
	if [ $num -eq 0 ]; then num=1
	elif [ $num -eq 10 ]; then num=9; fi

	#カーソル位置の取得
	for number in {1..9}
	do
		if [ $number -eq $num ]; then
			prin[${number}]="${C_cor}${Cor}${Cend}"
		else
			prin[${number}]="  "
		fi
	done

done


IFS=$IFS_BACKUP
