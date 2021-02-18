#!/bin/bash

IFS_BACKUP=$IFS
IFS=$`\n`
path="/"

for L in `ls -l $path`
do
	echo $L
done

IFS=$IFS_BACKUP
