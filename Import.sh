#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 1/29/2019
#Usage: ./Import

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

printf "${RED}[*]${NC} Starting at $(date)\n"

#Checks to see if the user is working out of the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then
	#  Checks to see if the Import directory is there
	if [ -d ./PutYourDataBasesHere ];then
		dataDir="$(pwd)"

		#  This loop is checking to see if any new files are in the PutYourDataBasesHere
		#  directory.If not then there is no reason to decompress and compress everything
		let i=0  # used to count the amount of files not already imported 
		declare -a arr
		 while read -r inputfile;do
			arr=(${inputfile})
			file_SHA_sum="$(sha256sum "$dataDir"/PutYourDataBasesHere/"$inputfile" | awk '{print$1}')"
			#  check to see if the database has already been imported
			if [ "$(grep "$file_SHA_sum" -c < ./Logs/importedDBS.log)" == "0" ];then
				let i=i+1
			fi
			_constr+="${arr[2]}"
		done< <(find PutYourDataBasesHere -type f -exec echo {} \; | cut -f 2- -d "/")

		# if there are files that need to be imported
		if [ $i -ne 0 ];then
			#  decompress all of the folders before priming and import
			printf "${YELLOW}[!]${NC} Decompressing all stored data\n"
			printf "[!] Decompressing all stored data\n" >> ./Logs/ActivityLogs.log
			./decompress.sh
			printf "${GREEN}[+]${NC} Finished decompressing!\n"
			printf "[+] Finished decompressing!\n" >> ./Logs/ActivityLogs.log

			#  Prime the data folder
			python3 folderPrimer.py

			#  Read each file in the input files, in sorted order
			find PutYourDataBasesHere -type f -exec echo {} \; | cut -f 2- -d "/" | while read -r inputfile;do
				file_SHA_sum="$(sha256sum "$dataDir"/PutYourDataBasesHere/"$inputfile" | awk '{print$1}')"
				#  check to see if the database has already been imported
				if [ "$(grep "$file_SHA_sum" -c < ./Logs/importedDBS.log)" == "0" ];then
					#  Call a python script to iterate through the file and sort them
					python3 pysort.py "$inputfile"
					printf "${YELLOW}[!] Adding $inputfile to importedDBS.log${NC}\n"
					echo "$file_SHA_sum" "$(date)" "$inputfile" >> "$dataDir"/Logs/importedDBS.log
					echo
				else
					printf "${YELLOW}[!]${NC} $inputfile SHASUM found in importedDBS.log\n"
					printf "[!] $inputfile SHASUM found in importedDBS.log\n" >> ./Logs/ActivityLogs.log
				fi
			done
			printf "${YELLOW}[!]${NC} Compressing all data\n"
			printf "[!] Compressing all data\n" >> ./Logs/ActivityLogs.log
			#  All data is stored. Time to compress
			./compress.sh
			printf "${GREEN}[+]${NC} Finished compressing!\n"
			printf "[+] Finished compressing!\n" >> ./Logs/ActivityLogs.log

		else # No new files found 
			echo
			printf "${RED}ERROR:${NC} No new files found in the 'PutYourDataBasesHere' directory \n"
			printf "ERROR: No new files found in the 'PutYourDataBasesHere' directory \n" >> ./Logs/ActivityLogs.log
			
		fi # check for imported files

	else    #  If the Import directory doesn't exist
		dataDir=$(pwd)
		printf "${RED}ERROR: Please make a directory called 'PutYourDataBasesHere' in $dataDir${NC}\n"
		printf "ERROR: Please make a directory called 'PutYourDataBasesHere' in $dataDir\n" >> ./Logs/ActivityLogs.log
	fi
else
	# If the users working directory is not BaseQuery while trying to run the script
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
	printf "ERROR: Please change directories to the BaseQuery root directory\n" >> ./Logs/ActivityLogs.log
fi
echo
printf "${RED}[*]${NC} Completed\n"
printf "[*] Completed\n" >> ./Logs/ActivityLogs.log




