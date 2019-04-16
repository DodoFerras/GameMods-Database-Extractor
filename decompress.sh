#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 2/16/2019
#Usage:   ./decompress.sh
#Usage:   ./decompress.sh <name of compressed file>
#Example: ./decompress.sh 0.tar.zst

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

#  Make sure the user is in the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then
	#  Check if no args were passed in; then decompress everything
	if [ $# -eq 0 ];then
		#  Iterate through all the compressed files 
		find data/ -type f -name "*.tar.zst" | sort | while read -r compressed_file; do
			#  check to make sure you dont decompress the working directory
			if [ "$compressed_file" != "data/" ];then
				#  Grabs the name of the file from the path
				name="$(echo $compressed_file | cut -f 2- -d "/" | cut -f 1 -d ".")"
				# decompress the .tar.zst files
				#tar --use-compress-program=zstd -xf ./data/0.tar.zst
				tar --use-compress-program=zstd -xf ./data/$name.tar.zst
				#  remove the old compressed files			
				rm -rf data/"$name".tar.zst
			fi	
		done
	elif [ $# -eq 1 ];then
		# make sur you dont try and decompress the working directory
		if [ "$1" != "data/" ];then
			# decompress the .tar.zst files
			#tar --use-compress-program=zstd -xf ./data/0.tar.zst
			tar --use-compress-program=zstd -xf ./data/"$1"
			#  remove the old compressed files			
			rm -rf data/"$1"
		fi
	else  # Wrong input
		printf "${RED}[!]${NC} Usage Error: ./decompress.sh \n"
		printf "${RED}[!]${NC} Usage Error: ./decompress.sh <name of compressed file>\n"
		
		printf "[!] Usage Error: ./decompress.sh \n" >> ./Logs/ActivityLogs.log
		printf "[!] Usage Error: ./decompress.sh <name of compressed file>\n" >> ./Logs/ActivityLogs.log
		
	fi
else
	# If the users working directory is not BaseQuery while trying to run the script
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	printf "ERROR: Please change directories to the BaseQuery root directory\n" >> ./Logs/ActivityLogs.log
fi
