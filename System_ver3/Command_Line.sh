#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_Set="$PATH_/List/Setting"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_cmd_hist="$PATH_/cmd_hist.txt"
############################################################
C_mode="\e[3`sed -n 9p $PATH_Set`m"; C_c="\e[3`sed -n 5p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"
Cend="\e[m"
supNum=`sed -n 1p $PATH_Set`; Cor="`sed -n 12p $PATH_Set`"
mode="Command_Line"
############################################################
shopt -s expand_aliases
alias ls='ls -C'
############################################################
rm $PATH_cmd_hist && touch $PATH_cmd_hist
line_sup=0; line_inf=1; line_op=0

#numの取得
IFS_BACKUP=$IFS
IFS=$'\n'
for line in `cat $PATH_file_show`
do
	case "$line" in
		*${Cor}*)
		num=$get_num
		;;
	esac
	get_num=$((get_num+1))
done

#show_numの取得
get_show_num=1
for line in `cat $PATH_cmd_hist`
do
	if [[ $line = *"${C_c}>${Cend}"* ]]; then get_show_num=$((get_show_num+1)); fi
done
if [ $get_show_num -eq 0 ]; then get_show_num=1; fi

#メイン
while [ $mode = "Command_Line" ]
do

	#mode=`cat $PATH_mode`
	clear

	#display
	number=$((num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p

	#コマンドライン
	echo; echo -e " ${C_mode}<Command Line>${Cend}"

	#範囲取得
	line_sup=`cat $PATH_cmd_hist | wc -l`
	if [ $line_sup -lt 0 ]; then line_sup=0; fi
	line_inf=$((line_sup-10))
	if [ $line_inf -le 0 ]; then line_inf=1; fi
	
	#描写
	line_=$line_inf
	#echo "line_=$line_    line_sup=$line_sup"
	while [ $line_ -le $line_sup ]
	do
		echo -e "${C_c}${line_}${Cend} `sed -n ${line_}p $PATH_cmd_hist`"
		line_=$((line_+1))
	done	

#	for line in `cat $PATH_cmd_hist`
#	do
#		echo -e "$line"
#	done


	#入力待機
	echo -ne "${C_c}$((line_sup+1))${Cend}  ${C_c}>${Cend}"
	roop=true; cmd_=""
	read _cmd_
	while [ $roop = "true" ]
	do
		read -n 1 _cmd
		if [ "${_cmd}" = "" ]; then roop=false
		else
			cmd_="${cmd_}${_cmd}"
		fi
	done
	
	#実行
	echo -ne "${C_caution}"
	eval ${cmd_} || read -n 1
	echo -e "${Cend}"
	#書き込み
        echo " ${C_c}>${Cend}${cmd_}" >> $PATH_cmd_hist
	echo "`eval ${cmd_} 2> /dev/null`" >> $PATH_cmd_hist

done






IFS=$IFS_BACKUP

