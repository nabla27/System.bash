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

cat $PATH_tpwd > $PATH_pwd

num=1
num_tpwd=1

function output(){
	local list_num="1"
	ls -F -w10 `cat $PATH_pwd` > $PATH_direct_list
	for line in `cat $PATH_direct_list`
	do
		if [ "$num" -eq "$list_num" ]; then
			echo " → $line" >> $PATH_file_show
		elif [ "$num" -ne "$list_num" ]; then
			echo "    $line" >> $PATH_file_show
		fi
		list_num=$((list_num+1))
	done
}

clear
while [ "$num" -gt "0" ]
do
	#描写ファイルの更新
	rm $PATH_file_show && touch $PATH_file_show 

	#描写ファイルの生成
	output

	#カレントディレクトリの描写
	cat $PATH_pwd
	echo 

	#画面への描写
	if [ "$num" -le "10" ]; then
		cat $PATH_file_show | head -n 10
	elif [ "$num" -gt "10" ]; then
	        cat $PATH_file_show | sed -n '10,20p'
	fi

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
		q)
		echo `pwd` >> $PATH_tpwd && cd .. && echo `pwd` > $PATH_pwd
		num=1
		num_tpwd=1
		;;
		e)
		cd `cat $PATH_tpwd | tail -n $num_tpwd | head -n 1` && echo `pwd` > $PATH_pwd
		num_tpwd=$((num_tpwd+1))
		num=1
		;;
		d)
		echo "subfield" > $PATH_mode
		exit
	esac
	clear
done

	

