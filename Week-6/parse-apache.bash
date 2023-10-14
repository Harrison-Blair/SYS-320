#!/bin/bash

#Storyline: Create a program that parses an apache log file and creates iptable rulesets for the ip's found within

read -p "Please enter the directory of the apache log file you wish to parse: " fileDir 

if [[ ! -f ${fileDir} ]]
then
	echo "File doesn't exist"
	exit 1
fi

awk '{match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); print substr($0, RSTART, RLENGTH)}' "${fileDir}" | sort -u | while read -r IPS
do
	if grep -qEi 'test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t' "${fileDir}"
	then
		echo "iptables -A INPUT -s ${IPS} -j DROP" >> blockedips.iptables
	fi
done
