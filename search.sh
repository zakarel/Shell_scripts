#!/bin/bash

#
#	The MULTI-SEARCHER v1.1
#	Created: Mar 2017
#       Updated: Mar 2021

input=$1
if [ -z "$1" ]
then
	echo "Usage: search [HostName].. ex: search my-server2"
	exit 1
fi

grep $input /etc/hosts >/dev/null
if [ $? -eq 0 ]
then
	grep $input /etc/hosts
else
	echo "Searching known hosts..."
	sleep 0.5
	grep $input ~/.ssh/known_hosts | awk 'BEGIN {FS=","}{print $2}'| awk '{print $1}' | grep -v "ssh-rsa"
	echo 
	echo "Locate file on the system?"
	read choice
	if [ $choice == "y" ]
	then	
		echo "Updating Locate Database..."
		updatedb
		locate $input
		if [ $? -ne 0 ]
		then 
			echo "Cant find $input anywhere"
		fi
	else
		echo "Bye!"
		exit 3
	fi
fi
