#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_direct_list="$PATH_/TMP_folder/direct_list.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_mode="$PATH_/TMP_folder/mode.txt"
PATH_Set="$PATH_/List/Setting"
############################################################
get_num=1
num_tpwd=1
mode="display"
Cend="\e[m"
C_dir=`sed -n 2p $PATH_Set`; C_path=`sed -n 4p $PATH_Set`; C_f=`sed -n 3p $PATH_Set`
supNum=`sed -n 1p $PATH_Set`

#subfieldからnumの取得
IFS_BACKUP=$IFS
IFS=$'\n'
for line in `cat $PATH_file_show`
do
	case "$line" in
		*→*)
		num=$get_num
		;;
	esac
	get_num=$((get_num+1))
done
IFS=$IFS_BACKUP

#描写
function output(){
	IFS_BACKUP=$IFS
	IFS=$'\n'
	local list_num=1
	ls -F -w10 `cat $PATH_pwd` > $PATH_direct_list
	for line in `cat $PATH_direct_list`
	do
		if [ "$num" -eq "$list_num" ]; then
			if [ -d "$line" ]; then echo -e " → ${list_num}. ${C_dir}$line${Cend}" >> "$PATH_file_show"
			elif [ -f "$line" ]; then echo " → ${list_num}. $line" >> "$PATH_file_show"
			else echo -e " → ${list_num}. ${C_f}$line${Cend}" >> "$PATH_file_show"; fi
		elif [ "$num" -ne "$list_num" ]; then
			if [ -d "$line" ]; then echo -e "    ${list_num}. ${C_dir}$line${Cend}" >> "$PATH_file_show"
			elif [ -f "$line" ]; then echo "    ${list_num}. $line" >> "$PATH_file_show"
			else echo -e "    ${list_num}. ${C_f}$line${Cend}" >> "$PATH_file_show"; fi
		fi
		list_num=$((list_num+1))
	done
	IFS=$IFS_BACKUP
}

clear
while [ $mode = "display" ]
do
	mode=`cat $PATH_mode`
	
	#描写ファイルの更新
	rm $PATH_file_show && touch $PATH_file_show 

	#描写ファイルの生成
	output

	#カレント0ディレクトリの描写
	echo `pwd` > $PATH_pwd
	echo -e "${C_path}`cat $PATH_pwd`${Cend}"
	echo 
	echo "[display]"
	echo "--------------------" 

	#画面への描写
	number=$((num/supNum)); inf=$((number*supNum)); sup=$((inf+supNum)); if [ $inf -eq 0 ]; then inf=1; fi
	cat $PATH_file_show | sed -n ${inf},${sup}p

	#キー入力待機
	read -n 1 _getch

	#キー入力によるパラメータ変更
	case "$_getch" in
		s)
		num=$((num+1))
		;;
		w)
		num=$((num-1))
		;;
		q|a)
		echo `pwd` >> $PATH_tpwd && cd .. && echo `pwd` > $PATH_pwd
		echo "→" > $PATH_file_show
		num_tpwd=1
		;;
		e)
		cd `cat $PATH_tpwd | tail -n $num_tpwd | head -n 1` && echo `pwd` > $PATH_pwd
		num_tpwd=$((num_tpwd+1))
		echo "→" > $PATH_file_show
		;;
		d)
		echo "subfield" > $PATH_mode
		exit
		;;
		:)
		echo "< Command Line > "
		read _getcher
		if expr "$_getcher" : "[0-9]*$" >&/dev/null; then
			mvd="`cat $PATH_pwd`/`cat $PATH_direct_list | sed -n ${_getcher}p`"
			if [ -f "$mvd" ]; then cat "$mvd"; read -n 1 a
			elif [ -d "$mvd" ]; then echo "→" > $PATH_file_show; cd $mvd
			else echo "cannot operate"; fi
		else
			if [[ "$_getcher" = cd* ]]; then echo "→" > $PATH_file_show; fi
			$_getcher
			read -n 1 a
		fi
		echo `pwd` > $PATH_pwd
		exit
		;;
		r)
		mode="menu" && echo "menu" > $PATH_mode
		exit
		;;
		[1-9])
		echo "--------------------"
		mvd="`cat $PATH_pwd`/`cat $PATH_direct_list | sed -n ${_getch}p`"
		if [ -f "$mvd" ]; then cat "$mvd"; read -n 1 a
		elif [ -d "$mvd" ]; then echo "→" > $PATH_file_show; cd "$mvd"
		else echo  "${_getch}'s file is not accessible."; read -n 1; fi
		echo `pwd` > $PATH_pwd; exit
		;;
		*)
		echo "Not an assgined key."
		;;
	esac
	clear
	
	#numの制約
	num_sup=`cat $PATH_file_show | wc -l`
	if [ $num -gt $num_sup ]; then num=$num_sup; fi
	if [ $num -eq 0 ]; then num=1; fi
done

	

