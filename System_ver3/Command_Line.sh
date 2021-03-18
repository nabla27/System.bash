#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_Set="$PATH_/List/Setting"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_cmd_hist="$PATH_/TMP_folder/cmd_hist.txt"
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
line_sup=0; line_inf=1; line_op=0; get_hist=0
cmd_mode="__getch"; comment=""; upd=0; sn=0; line_tmp_sup=`cat $PATH_cmd_hist | wc -l`

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

function Get_cmd_hist(){
	if [ $sn -le 0 ]; then sn=0; comment=""
	elif [ $sn -ge $get_hist ]; then sn=$get_hist; fi
	local get_line=0; get_hist=0
	while [ $get_line -lt $line_tmp_sup ]
	do
		tmp_comment=`sed -n $((line_tmp_sup-get_line))p $PATH_cmd_hist`
		if [[ $tmp_comment = *">"* ]]; then 
			get_hist=$((get_hist+1))
			if [ $sn -eq $get_hist ]; then comment=`echo ${tmp_comment#*>"\e[m"}`; fi
		fi
		get_line=$((get_line+1))
	done
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
	Get_cmd_hist

	#カレントディレクトリの描写
	echo `pwd` > $PATH_pwd
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo
	echo -e "${C_mode}[display]${Cend}"
	echo "--------------------"
	
	#display
	number=$((num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p
	get_blank=1; blank_num=0
	for line in `cat $PATH_file_show`
	do
		if [ $get_blank -ge $inf ]; then blank_num=$((blank_num+1)); fi
		get_blank=$((get_blank+1))
	done
	if [ $blank_num -gt $supNum ]; then blank_num=$supNum; fi
	blank_count=0; #blank_sup=$((supNum-blank_num))
	while [ $blank_count -lt $((supNum-blank_num)) ]
	do
		echo
		blank_count=$((blank_count+1))
	done
	
		

	#コマンドライン
	if [ "$cmd_mode" = "__getch" ]; then
		#echo; echo -e " ${C_mode}<Command Line>${Cend}"
		echo; echo -e "\e[3`sed -n 9p $PATH_Set`;4m [Command Line]                    ${Cend}"
	elif [ "$cmd_mode" = "getch__" ]; then
		echo; echo -e "\e[3`sed -n 9p $PATH_Set`;4m [Command Line]      ${C_c}--processing--${Cend}${Cend}"
	fi

	#範囲取得
	line_tmp_sup=`cat $PATH_cmd_hist | wc -l`
	if [ $line_tmp_sup -lt 0 ]; then line_tmp_sup=0; fi
	line_tmp_inf=$((line_tmp_sup-10))
	if [ $line_tmp_inf -le 0 ]; then line_tmp_inf=1; fi
	#########
	line_sup=$((line_tmp_sup-upd))
	line_inf=$((line_tmp_inf-upd))
	
	#描写
	line_=$line_inf
	while [ $line_ -le $line_sup ]
	do
		echo -e "${C_c}${line_}${Cend} `sed -n ${line_}p $PATH_cmd_hist`"
		line_=$((line_+1))
	done
	if [ "$cmd_mode" = "getch__" ]; then
		read -s -n 1 -p `echo -e "${C_c}$((line_tmp_sup+1))${Cend}  ${C_c}>${Cend}${comment}"` _key
	elif [ "$cmd_mode" = "__getch" ]; then
		comment=""
	fi	

	#入力待機
	if [ "$cmd_mode" = "__getch" ]; then
		read -ep `echo -e "${C_c}$((line_sup+1))${Cend}  ${C_c}>${Cend}"` _cmd
	fi
	
	#コマンド実行
	if [ "$cmd_mode" = "__getch" ]; then
	case "${_cmd}" in
		exit)
		mode="display" && echo "display" > $PATH_mode && exit
		;;
		[1-9]|[1-9][0-9]|[1-9][0-9][0-9])
		if [ "${_cmd}" -le `cat $PATH_direct_list | wc -l` ]; then
			mvfile=`sed -n ${_cmd}p $PATH_direct_list`
			if [ -d "${mvfile}" ]; then
				cd "${mvfile}" && echo `pwd` > $PATH_pwd
			elif [ -f "${mvfile}" ]; then
				cat "${mvfile}"; read -s -n 1
			fi
			mode="display" && echo "display" > $PATH_mode && exit
			num=1
		fi
		;;
		"]")
		num=$((num+supNum))
		if [ $num -gt `cat $PATH_direct_list | wc -l` ]; then
			num=`cat $PATH_direct_list | wc -l`
		fi
		;;
		"[")
		num=$((num-supNum))
		;;
		:)
		cmd_mode="getch__"
		sn=0
		;;
		*)
		eval "${_cmd}" || read -s -n 1
		echo `pwd` > "$PATH_pwd"; output
		num=1
		;;
	esac
	elif [ "$cmd_mode" = "getch__" ]; then
	case "${_key}" in
		w)
		if [ $((line_tmp_inf-upd-1)) -gt 0 ]; then upd=$((upd+1)); fi
		;;
		s)
		if [ $((line_tmp_sup-upd+1)) -le $line_tmp_sup ]; then upd=$((upd-1)); fi
		;;
		d)
		sn=$((sn+1))
		;;
		a)
		sn=$((sn-1))
		;;
		:)
		cmd_mode="__getch"
		;;
		"")
		if [ "$comment" != "" ]; then
		echo " ${C_c}>${Cend}${comment}" >> $PATH_cmd_hist
		tf_ex="true"
		case "$comment" in
			*vim*|*less*)
			tf_ex="true"
			;;
			*cat*)
			if [ `echo "${comment}" | awk '{print NF}'` -eq 2 ]; then read -s -n 1
				tf_ex="false"
			else
				tf="true"
			fi
			;;&
			*)
			result=`eval "${comment}" 2> /dev/null`
			if [ "${result}" != "" -a $tf_ex = "true" ]; then
				echo "`eval "${comment}" 2> /dev/null`" >> $PATH_cmd_hist
			fi
			;;
		esac
		cmd_mode="__getch"
		fi
		;;
		*)
		;;
	esac
	fi

	#書き込み
	if [ "$cmd_mode" = "__getch" ]; then
		if [ "$_cmd" != "[" -a "$_cmd" != "]" -a "$_key" != ":" -a "$comment" = "" ]; then
        		echo " ${C_c}>${Cend}${_cmd}" >> $PATH_cmd_hist
		fi
		if [ "$_cmd" != "" ]; then
			tf_ex="true"
			case "$_cmd" in	
				*vim*|*less*)				#出力が端末でなければならないコマンド
				tf_ex="true"
				;;
				*cat*)
				if [ `echo "${_cmd}" | awk '{print NF}'` -eq 2 ]; then read -s -n 1
					tf_ex="false"
				else
					tf_ex="true"
				fi
				;;&
				"["|"]")
				;;
				*)
				result=`eval ${_cmd} 2> /dev/null`
				if [ "${result}" != "" -a $tf_ex = "true" ]; then
					echo "`eval ${_cmd} 2> /dev/null`" >> $PATH_cmd_hist
				fi
				;;
			esac
		fi
	fi

done






IFS=$IFS_BACKUP

