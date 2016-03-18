#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

for i in 1 2 3 4      #Currently max 5 connected devices are supported
do
	a=$(adb devices|awk -F 'device' '{print $1}'|sed '1d'|tr -d '\n'|tr '[[:blank:]]/' ','|awk -v b="$i" -F ',' '{print $b}')
	if [ ! -z "$a" ]; then
		echo
		model=$(adb -s $a shell  getprop ro.product.model)
		echo 
		echo ${bold}Removing apps from device: $model${normal}	
		echo ============================================

		# adb -s $a shell rm -R /sdcard/com.appcelerator.*
		pkg=$(adb -s $a shell pm list packages | grep -i com.appc* | tr -d "\r")
		if [ ! -z "$pkg" ]; then
			adb -s $a shell pm list packages | grep -i com.appc* | tr -d "\r" | while read line;
			do
				echo ${line:8};
				adb -s $a uninstall ${line:8};
			done
		else
			echo No titanium apps installed.
			echo
		fi
	fi
done
