#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 2/16/2019
#Usage: ./compress.sh

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

#  Make sure the user is in the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then
	let orig_bytes=0
	declare -a arr
	#  Find all of the uncompressed directories 
	while read -r uncompressed_dir; do
		arr=(${uncompressed_dir})
		if [ "$uncompressed_dir" != "data/" ];then
			file_bytes=$(du -sb "$uncompressed_dir"/ | cut -f 1)
			let orig_bytes=$orig_bytes+$file_bytes
			name="$(echo $uncompressed_dir | cut -f 2- -d "/")"
			#tar --use-compress-program=zstd -cf data/0.tar.zst data/0
			tar --use-compress-program=zstd -cf data/"$name".tar.zst "$uncompressed_dir"
			rm -rf "$uncompressed_dir"
		fi
		_constr+="${arr[2]}"	
	done< <(find data/ -maxdepth 1 -type d | sort)

	compressed_bytes=$(du -sb data/ | cut -f 1)
	if [[ $orig_bytes -ne 0 && $compressed_bytes -ne 0 ]];then
		comp_div_ori=$( awk -v orig=$orig_bytes -v comp=$compressed_bytes 'BEGIN{printf("%.2f\n",comp/orig*100)}' )
		multiples_compressed=$(( $orig_bytes/$compressed_bytes ))
		echo 
		printf "${RED}[*] Your data is $multiples_compressed""x times smaller! (~$comp_div_ori%% of the original size)${NC}\n"
		printf "${YELLOW}[!] Original number of bytes	$orig_bytes${NC}\n"
		printf "${YELLOW}[!] Compressed number of bytes	$compressed_bytes${NC}\n"

		printf "[*] Your data is $multiples_compressed""x times smaller! (~$percentage_compressed%% of the original size)\n" >> ./Logs/ActivityLogs.log
		printf "[!] Original number of bytes	$orig_bytes\n" >> ./Logs/ActivityLogs.log
		printf "[!] Compressed number of bytes	$compressed_bytes\n" >> ./Logs/ActivityLogs.log
	fi
	
else
	# If the users working directory is not BaseQuery while trying to run the script
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"

	printf "ERROR: Please change directories to the BaseQuery root directory\n" >> ./Logs/ActivityLogs.log
fi
	

