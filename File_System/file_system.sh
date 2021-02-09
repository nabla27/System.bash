#!/bin/bash

clear
num=`sed -n 2p ~/data_folder/System/File_System/memory_File_System`
pwd=`sed -n 1p ~/data_folder/System/GUI_System/tmp_pwd`


function output(){
	local list_num=1
	ls -F -w 10 "$pwd" > ~/data_folder/System/File_System/directory_list
	for line in `cat ~/data_folder/System/File_System/directory_list`
	do
		if [ "$num" -eq "$list_num" ]; then
			echo " → $line" >> ~/data_folder/System/File_System/file_system.txt
		elif [ "$num" -ne "$list_num" ]; then
			echo "    $line" >> ~/data_folder/System/File_System/file_system.txt
		fi

		list_num=$((list_num+1))
	done
}



while [ "$num" -gt "0" ]
do
	#描写ファイルの更新　
	rm ~/data_folder/System/File_System/file_system.txt && touch ~/data_folder/System/File_System/file_system.txt
	
	#描写のためのファイルを生成
	output

	#カレントディレクトリの生成
	echo "$pwd"
	echo

	#画面への描写
	if [ "$num" -le "10" ]; then
		cat ~/data_folder/System/File_System/file_system.txt | head -n 10
	elif [ "$num" -gt "10" ]; then
		cat ~/data_folder/System/File_System/file_system.txt | sed -n '10,20p'
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
		tmp_pwd=`pwd` && pwd=`pwd` #cd .. #これがなくてもqでディレクトリが戻ってしまう。
		num=1
		;;
		e)
		cd "$tmp_pwd" && pwd=`pwd`
		num=1
		;;
		d)
		echo "subfield" > ~/data_folder/System/GUI_System/GUI_mode
	   	echo "$pwd/`sed -n "$num"p ~/data_folder/System/File_System/directory_list`" > ~/data_folder/System/File_System/memory_File_System
		echo "$num" >> ~/data_folder/System/File_System/memory_File_System
		echo "$pwd" > ~/data_folder/System/GUI_System/tmp_pwd
		echo 
		exit
		;;
	esac
	clear
done

