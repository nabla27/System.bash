#!/bin/bash

clear

echo "This file is setup file."
echo "if you execute this, all data such as trash_boxs and bookmarks will be cleared."
echo "Do you want to do it(y/n)??"
read -s -n 1 _yn
if [ $_yn != y ]; then
	bash main.sh
else
######################################################################################
PATH_="`pwd`"

rm "$PATH_/TMP_folder/book_mark.txt"   && touch "$PATH_/TMP_folder/book_mark.txt"
rm "$PATH_/TMP_folder/cmd_hist.txt"    && touch "$PATH_/TMP_folder/cmd_hist.txt"
rm "$PATH_/TMP_folder/direct_list.txt" && touch "$PATH_/TMP_folder/direct_list.txt"
rm "$PATH_/TMP_folder/search_file.txt" && touch "$PATH_/TMP_folder/search_file.txt"
rm "$PATH_/TMP_folder/show_file.txt"   && touch "$PATH_/TMP_folder/show_file.txt"
rm "$PATH_/TMP_folder/show_sf.txt"     && touch "$PATH_/TMP_folder/show_sf.txt"

rm -r "$PATH_/List/Trash_Boxd" && mkdir "$PATH_/List/Trash_Boxd"
rm -r "$PATH_/List/Trash_Boxf" && mkdir "$PATH_/List/Trash_Boxf"

bash main.sh

fi
