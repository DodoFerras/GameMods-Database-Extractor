#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 1/29/2019
#Usage: ./query.sh test@example.com
#Usage: ./query.sh test@
#Usage: ./query.sh @example.com
#Usage: ./query.sh /home/user/Desktop/file.txt

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

#  Checks to see if the user forgot to enter input
if [ $# -eq 1 ];then
	if [ "${PWD##*/}" == "BaseQuery" ];then
		# Checks to see if the file exists in the working directory
		if ! [ -e "$1" ];then
			#  Only one email
			./search.sh "$1"
		else
			# A file was inputed
			filename="$(echo $1 | rev | cut -f 1 -d "/" | rev)" #test.txt
			printf "${GREEN}[+]${NC} Outputting all results to ${GREEN}./OutputFiles/""$(echo $filename | cut -f 1 -d "." )""_output.txt${NC}\n"
			cat "$1" | while read -r email;do
				#echo
				#  The first param is the email address the second is telling ./search that it 
				#  is a file so the user is not prompted
				./search.sh "$email" "$filename"
				
			done
		fi
	else
		printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	fi
else
	printf "${YELLOW}[!]${NC} Please enter one email address or a file with one email address per line\n"
fi
