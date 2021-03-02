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

rm $PATH_cmd_hist && touch $PATH_cmd_hist

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

	mode=`cat $PATH_mode`; clear

	#display
	number=$((num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p

	#コマンドライン
	echo; echo -e " ${C_mode}<Command Line>${Cend}"
	#描写範囲の取得
	count=1; cm_count=1
	for line in `cat $PATH_cmd_hist`
	do
		if [[ "$line" = *"${C_c}>${Cend}"* ]]; then
			cm_line[$cm_count]=$count
			cm_count=$((cm_count+1))
		fi
		count=$((count+1))
	done
	echo -e `cat $PATH_cmd_hist | tail -n 5`


	#入力待機
	echo -ne " ${C_c}>${Cend} "; read _cmd
	#実行
	eval ${_cmd} || echo -e "${C_caution}"
	echo -e "${Cend}"; echo " ${C_c}>${Cend} $_cmd" >> $PATH_cmd_hist
	eval ${_cmd} >> $PATH_cmd_hist

done






IFS=$IFS_BACKUP

