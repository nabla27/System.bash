#!/bin/bash

PATH_prog="/home/nalba27_2/data_folder/System.bash/progress.txt"
PATH_show="/home/nabla27_2/data_folder/System.bash/show_file"

rm $PATH_show && touch $PATH_show

echo "Enter the path"
read _path
echo "***************waiting****************"
num_file=`ls -pR -U1 $_path | grep -v -e / -e '^\s*$' | wc -l`
block=$((num_file/100))                                                                                  #|     
echo "____________________________________________________________________________________________________|${num_file}"

IFS_BACKUP=$IFS
IFS=$'\n'
count=0; num_show=1
function search(){
	if [ $count -gt $((block*num_show)) -a $num_show -le 100 -a $num_file -ge 100 ]; then
		echo -n "/"
		num_show=$((num_show+1))
	fi
	local path=$1
	if [ -f "$path" -o -h "$path" ]; then
		ls -l "$path" >> $PATH_show
		count=$((count+1))
	elif [ -d "$path" ]; then
		local fname
		for fname in `ls "$path"`
		do
			search "${path}/${fname}"
		done
	fi
}

search "$_path"

echo
IFS=$IFS_BACKUP
