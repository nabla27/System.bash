#!/bin/bash
############################################################
PATH_="/home/nabla27_2/data_folder/System.bash/System_ver3"
############################################################
PATH_tpwd="$PATH_/TMP_folder/tmp_pwd.txt"
PATH_pwd="$PATH_/TMP_folder/pwd.txt"
PATH_direct_list="$PATH_/TMP_folder/direct_list.txt"
PATH_file_show="$PATH_/TMP_folder/show_file.txt"
PATH_mode="$PATH_/TMP_folder/mode.txt"
############################################################
get_num=1
num_tpwd=1

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
			echo " → ${list_num}. $line" >> "$PATH_file_show"
		elif [ "$num" -ne "$list_num" ]; then
			echo "    ${list_num}. $line" >> "$PATH_file_show"
		fi
		list_num=$((list_num+1))
	done
	IFS=$IFS_BACKUP
}

clear
while [ "$num" -gt "0" ]
do
	#描写ファイルの更新
	rm $PATH_file_show && touch $PATH_file_show 

	#描写ファイルの生成
	output

	#カレント0ディレクトリの描写
	echo `pwd` > $PATH_pwd
	cat $PATH_pwd
	echo 
	echo "[display]"
	echo "--------------------" 

	#画面への描写
	number=$((num/10)); inf=$((number*10)); sup=$((inf+10)); if [ $inf -eq 0 ]; then inf=1; fi
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
		$_getcher
		echo `pwd` > $PATH_pwd
		exit
		;;
		r)
		mode="menu" && echo "menu" > $PATH_mode
		exit
		;;
	esac
	clear
	
	#numの制約
	num_sup=`cat $PATH_file_show | wc -l`
	if [ $num -gt $num_sup ]; then num=$num_sup; fi
done

	

