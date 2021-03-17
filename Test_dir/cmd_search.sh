#!/bin/bash
###############################################################
PATH_="/home/nabla27/data_folder/System.bash/System_ver3"
###############################################################
PATH_cmdlist="$PATH_/List/CMD.List/cmd.bash"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_Set="$PATH_/List/Setting"
###############################################################
C_path="\e[3`sed -n 4p $PATH_Set`m"; C_mode="\e[3`sed -n 9p $PATH_Set`m"; C_title="\e[3`sed -n 6p $PATH_Set`m"
C_cor="\e[3`sed -n 11p $PATH_Set`m"
Cend="\e[m"; Cor="`sed -n 12p $PATH_Set`"


sp[1]="${C_cor}${Cor}${Cend}"; sp[2]="  "; sp[3]="  "; sp[4]="  "; sp[5]="  "; sp[6]="  "; sp[7]="  "
sp4[1]="  "; sp4[2]="  "; sp[3]="  "; sp[4]="  "; sp[5]="  "
num=1; num4=0



mode="cmd_search"

while [ $mode = "cmd_search" ]
do
	clear
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display] > [menu] > [cmd_search]${Cend}"
	echo -e "********************${C_title}cmd_search${Cend}********************"
	echo
	echo -e "${sp[1]} command name                      ["${s_cmd}"]"
	echo -e "${sp[2]} option name                       ["${s_opt}"]"
	echo -e "${sp[3]} keyword"
	echo -e "${sp[4]} ${sp4[1]}["${s_key1}"] ${sp4[2]}["${s_key2}"] ${sp4[3]}["${s_key3}"] ${sp4[4]}["${s_key4}"] ${sp4[5]}["${s_key5}"]"
	echo
	echo -e "${sp[5]} Clear"
	echo -e "${sp[6]} Search"
	echo -e "${sp[7]} list"
	echo
	echo    "*******************************************************************"

	read -s -n 1 _key
	case $_key in
		w)
		num=$((num-1))
		;;
		s)
		num=$((num+1))
		;;
		q)
		mode="menu"; exit
		;;
		a)
		if [ $num4 -ge 1 ]; then num4=$((num4-1))
		else mode="menu"; exit; fi
		;;
		d)
		if [ $num -eq 4 ]; then num4=$((num4+1))
		elif [ $num -eq 1 ]; then
			echo "1"; read -s -n 1
		elif [ $num -eq 2 ]; then
			echo "2"; read -s -n 1
		elif [ $num -eq 3 ]; then
			echo "3"; read -s -n 1
		elif [ $num -eq 5 ]; then
			echo "5"; read -s -n 1
		elif [ $num -eq 6 ]; then
			echo "6"; read -s -n 1
		elif [ $num -eq 7 ]; then
			echo "7"; read -s -n 1
		fi
		;;
	esac

	#パラメータの制約
	if [ $num -le 0 ]; then num=1
	elif [ $num -gt 7 ]; then num=7; fi
	if [ $num != 4 -a $num4 -ge 1 ]; then num4=0; fi
	if [ $num4 -lt 0 ]; then num4=0
	elif [ $num4 -gt 5 ]; then num4=5; fi

	#カーソルの設定
	for number in {1..7}
	do
		if [ $number -eq $num ]; then sp[$number]="${C_cor}${Cor}${Cend}"
		else sp[$number]="  "; fi
	done
	for number in {1..5}
	do
		if [ $number -eq $num4 ]; then sp4[$number]="${C_cor}${Cor}${Cend}"
		else sp4[$number]="  "; fi
	done


























done

