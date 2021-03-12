#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_Set="$PATH_/List/Setting"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_cmd_hist="$PATH_/cmd_hist.txt"
PATH_direct_list="$PATH_/TMP_folder/direct_list.txt"
############################################################
C_mode="\e[3`sed -n 9p $PATH_Set`m"; C_c="\e[3`sed -n 5p $PATH_Set`m"; C_caution="\e[3`sed -n 7p $PATH_Set`m"
C_dir="\e[3`sed -n 2p $PATH_Set`m"; C_path="\e[3`sed -n 4p $PATH_Set`m"; C_f="\e[3`sed -n 3p $PATH_Set`m"
C_nf="\e[3`sed -n 8p $PATH_Set`m"; C_cor="\e[3`sed -n 11p $PATH_Set`m"
Cend="\e[m"
supNum=`sed -n 1p $PATH_Set`; Cor="`sed -n 12p $PATH_Set`"; tf_hf="`sed -n 13p $PATH_Set`"
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

function _error(){
	echo -ne "${C_caution}"
}

function error_(){
	read -s -n 1; echo "${Cend}"
}

#output
function output(){
	if expr "$num" : "[0-9]*$" >&/dev/null; then num=$num
	else num=1; fi
	IFS_BACKUP=$IFS
	IFS=$'\n'
	local list_num=1
	if [ $tf_hf = No ]; then _error; ls -1 `cat $PATH_pwd` > $PATH_direct_list || error_
	elif [ $tf_hf = Yes ]; then _error; ls -1 -A `cat $PATH_pwd` > $PATH_direct_list || error_; fi
	for line in `cat $PATH_direct_list`
	do
		if [ "$num" -eq "$list_num" ]; then
			if [ -h "$line" ]; then echo -e " ${C_cor}${Cor}${Cend} ${list_num} ${C_f}${line}@${Cend}" >> "$PATH_file_show"
			elif [ -d "$line" ]; then echo -e " ${C_cor}${Cor}${Cend} ${list_num} ${C_dir}${line}/${Cend}" >> "$PATH_file_show"
			elif [ -f "$line" ]; then echo -e " ${C_cor}${Cor}${Cend} ${list_num} ${C_nf}${line}${Cend}" >> "$PATH_file_show"
			else echo -e " ${C_cor}${Cor}${Cend} ${list_num} ${C_f}${line}${Cend}" >> "$PATH_file_show"; fi
		elif [ "$num" -ne "$list_num" ]; then
			if [ -h "$line" ]; then echo -e "    ${list_num} ${C_f}${line}@${Cend}" >> "$PATH_file_show"
			elif [ -d "$line" ]; then echo -e "    ${list_num} ${C_dir}${line}/${Cend}" >> "$PATH_file_show"
			elif [ -f "$line" ]; then echo -e "    ${list_num} ${C_nf}${line}${Cend}" >> "$PATH_file_show"
			else echo -e "    ${list_num} ${C_f}${line}${Cend}" >> "$PATH_file_show"; fi
		fi
		list_num=$((list_num+1))
	done
	IFS=$IFS_BACKUP
}


#メイン
while [ $mode = "Command_Line" ]
do
	clear
	mode=`cat $PATH_mode`
	
	#描写ファイルの更新
	rm $PATH_file_show && touch $PATH_file_show

	#描写ファイルの更新
	output

	#カレントディレクトリの描写
	echo `pwd` > $PATH_pwd
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display]${Cend}"
	echo "--------------------"
	
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



	#入力待機
	read -ep `echo -e "${C_c}$((line_sup+1))${Cend}  ${C_c}>${Cend}"` _cmd
	
	#条件実行
	if [ "${_cmd}" = "exit" ]; then
		mode="display" && echo "display" > $PATH_mode; exit
	fi

	#コマンド実行
	eval "${_cmd}" || read -s -n 1
	echo `pwd` > "$PATH_pwd"; output
	#書き込み
        echo " ${C_c}>${Cend}${_cmd}" >> $PATH_cmd_hist
	echo "`eval ${_cmd} 2> /dev/null`" >> $PATH_cmd_hist

done






IFS=$IFS_BACKUP

