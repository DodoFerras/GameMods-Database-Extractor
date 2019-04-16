#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 1/29/2019
#Usage: ./run.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

#change the window size to fit the art
# requires xterm as a dependency 
resize -s 25 134

#ctrl+C
trap finish INT

function finish {
	printf "[*] Exit Trap Reached (CTRL+C)\n" >> ./Logs/ActivityLogs.log
	clear
	exit
}

clear
echo "           _               _                  _            _               _       _                  _            _    _        _   "
echo "          / /\            / /\               / /\         /\ \            /\ \    /\_\               /\ \         /\ \ /\ \     /\_\ "
echo "         / /  \          / /  \             / /  \       /  \ \          /  \ \  / / /         _    /  \ \       /  \ \\\\ \ \   / / / "
echo "        / / /\ \        / / /\ \           / / /\ \__   / /\ \ \        / /\ \ \ \ \ \__      /\_\ / /\ \ \     / /\ \ \\\\ \ \_/ / /  "
echo "       / / /\ \ \      / / /\ \ \         / / /\ \___\ / / /\ \_\      / / /\ \ \ \ \___\    / / // / /\ \_\   / / /\ \_\\\\ \___/ /   "
echo "      / / /\ \_\ \    / / /  \ \ \        \ \ \ \/___// /_/_ \/_/     / / /  \ \_\ \__  /   / / // /_/_ \/_/  / / /_/ / / \ \ \_/    "
echo "     / / /\ \ \___\  / / /___/ /\ \        \ \ \     / /____/\       / / / _ / / / / / /   / / // /____/\    / / /__\/ /   \ \ \     "
echo "    / / /  \ \ \__/ / / /_____/ /\ \   _    \ \ \   / /\____\/      / / / /\ \/ / / / /   / / // /\____\/   / / /_____/     \ \ \    "
echo "   / / /____\_\ \  / /_________/\ \ \ /_/\__/ / /  / / /______     / / /__\ \ \/ / / /___/ / // / /______  / / /\ \ \        \ \ \   "
echo "  / / /__________\/ / /_       __\ \_\\\\ \/___/ /  / / /_______\   / / /____\ \ \/ / /____\/ // / /_______\/ / /  \ \ \        \ \_\  "
echo "  \/_____________/\_\___\     /____/_/ \_____\/   \/__________/   \/________\_\/\/_________/ \/__________/\/_/    \_\/         \/_/  "
echo 


#Make sure that the user is in the BaseQuery directory
if [ "${PWD##*/}" == "BaseQuery" ];then

	#Log entry
	echo "[*] Executed run.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log

	while true;do
		echo
		echo "Options:"
		echo "		[1] Import Your data"
		echo "		[2] Calculate Import Time"
		echo "		[3] Query"
		echo "		[4] Harvest Email Addresses"
		echo "		[5] Message"
		echo "		[Q] Quit"
		echo
		read -p "Option Number-> " answer

		#  Check to see if the answer is only letters
		if [[ "$answer" =~ ^[a-zA-Z]+$ ]];then
			if [[ "$answer" == [Qq] ]];then
				# Log entry
				echo "[*] run.sh COMMAND 'q'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo >> ./Logs/ActivityLogs.log
				clear
				exit
			fi

		#  Check to see if the answer is only numbers
		elif [[ "$answer" =~ ^[0-9]+$ ]];then
			
			if [ "$answer" -eq 1 ];then
				#Log entry
				echo "[+] run.sh COMMAND '1'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo "[!] Executing ./Import.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log
				start=$SECONDS
				./Import.sh
				stop=$SECONDS
				difference=$(( stop - start ))
				printf "${GREEN}[!]${NC} The entire import including compression and decompression took $difference seconds\n"
				echo

			elif [ "$answer" -eq 2 ];then
				echo
				printf "${YELLOW}Make sure you have at least one file with at least 20,000 lines in PutYourDataBasesHere/${NC}\n"
				echo

				while true;do
					echo "Please enter the number of lines you wish to import... "
					read -p "('q' to quit) Lines>> " num_lines
					echo
					if [[ $num_lines != [Qq] ]]; then
						if [[ "$num_lines" =~ ^[0-9]+$ ]];then
							# Log Entry
							echo "[+] run.sh COMMAND '2' arg [$num_lines]	[ $(date) ]" >> ./Logs/ActivityLogs.log
							path="$(pwd)"
							while read -r inputfile;do
								num="$(wc -c < "$path"/PutYourDataBasesHere/"$inputfile")"
								if [ "$num" -ge 20000 ];then
									printf "${GREEN}[+]${NC} Decompressing files\n"
									./decompress.sh
									printf "${GREEN}[+]${NC} Starting Benchmark!\n"
									python3 benchmark.py "$inputfile" "$num_lines"
									break
								fi

							done< <(find PutYourDataBasesHere -type f -exec echo {} \; | cut -f 2- -d "/")

						else
							printf "${YELLOW}[!]${NC} Invalid input\n"
						fi
						echo

					else # If the user enters q or Q
						printf "${YELLOW}[!]${NC} Exiting Calculate Import Time\n"
						printf "${GREEN}[+]${NC} Compressing files\n"
						./compress.sh
						echo
						printf "${GREEN}[!]${NC} Compression completed!\n"
						break
					fi
				done
				

			elif [ "$answer" -eq 3 ];then
				echo
				printf "Please enter enter an email address in one of the following formats \n"
				printf "	ex) test@example.com			 [ Searches for all passwords associated with this address ]\n"
				printf "	ex) test@				 [ Searches for all passwords for any email addresses starting with this username ]\n"
				printf "	ex) @example.com			 [ Searches for all passwords for any email addresses ending with this domain name ]\n"
				printf "	ex) /home/user/Desktop/email_list.txt	 [ Searches line by line through the file for all passwords for each email address ]\n\n"
				while true;do
					read -p "('q' to quit) Email>> " email
					if [[ $email != [Qq] ]]; then
						if [ "$email" != "" ];then
							# Log Entry
							echo "[+] run.sh COMMAND '3' arg [$email]	[ $(date) ]" >> ./Logs/ActivityLogs.log
							echo "[!] Executing query.sh	[ $(date) ]" >> ./Logs/ActivityLogs.log
							./query.sh "$email"
							echo
						else
							continue
						fi
					else
						echo
						printf "${YELLOW}[!]${NC} Exiting Query\n"
						break
					fi
				done

				#  Compress all of the data
				echo 
				printf "${YELLOW}[!]${NC} Compressing all stored data\n"
				./compress.sh
				printf "${GREEN}[+]${NC} Finished compressing!\n"
				echo
				
			elif [ "$answer" -eq 4 ];then
				echo
				echo "[+] run.sh COMMAND '4'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				printf "${GREEN}Code taken from https://github.com/laramies/theHarvester${NC}\n"
				printf "${GREEN}		   Go check him out${NC}\n"
				# Check if theHarvester is already installed
				if ! [ -d ./theHarvester ];then
					printf "${YELLOW}[!]${NC} Installing theHarvester\n"
					git clone https://github.com/laramies/theHarvester.git #&> /dev/null
				fi

				# Install all of the requirements
				printf "${YELLOW}[!]${NC} Updating requirements\n"
				sudo python3 -m pip install -r ./theHarvester/requirements.txt #&> /dev/null

				printf "${YELLOW}[!] PLACE ANY API KEYS IN $(pwd)/theHarvester/api-keys.yaml${NC}\n"		
				echo "Domain name? ex) google.com"
				read -p "> " domain
				echo "Limit for the amount of email addresses? ex) 500"
				read -p "> " limit
				printf "
	${RED}source:${NC} baidu, bing, bingapi, censys, crtsh, cymon,
	dogpile, duckduckgo, google, googleCSE, google-
	certificates, google-profiles, hunter, intelx,
	linkedin, netcraft, pgp, securityTrails, threatcrowd,
	trello, twitter, vhost, virustotal, yahoo, all\n"
				echo
				echo "Source? ex) all"
				read -p "> " source 
				sudo python3 ./theHarvester/theHarvester.py -d "$domain" -l "$limit" -b "$source"
				echo
				printf "${RED}COPY ONLY THE EMAIL ADDRESSES AND SAVE THEM TO A .TXT FILE${NC}\n"
				printf "${RED}YOU CAN USE THE TEXT FILE AS INPUT TO QUERY ALL OF THEM AT ONCE${NC}\n"
				echo

			elif [ "$answer" -eq 5 ];then
				# Log Entry
				echo "[+] run.sh COMMAND '5'	[ $(date) ]" >> ./Logs/ActivityLogs.log
				echo
				echo "Hey... thanks for downloading Base Query, I've spent way too many hours coding this"
				echo "Base Query is a OSINT tool to help you organize and query all those pesky databases you have laying around"
				echo "With a quadruple nested structure and a careful design your querys should be INSTANTANEOUS! Or ya know like really fast."
				echo "Something broken? Check the logs and then message me!"
				echo "For more information regarding use check the README.md file"
				echo "Found a bug? Just want to talk? Message me on GitHub or Twitter https://github.com/g666gle"
				echo "					                        https://twitter.com/g666gle1"
				echo "													         V1.5"
				echo 

			fi

		fi
		read -sp "Press Enter to continue..." 
		clear
		
	done
else
	#Log entry
	echo "[!] ERROR: run.sh NOT executed in the BaseQuery directory; Exiting	[ $(date) ]" >> ./Logs/ActivityLogs.log
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
fi


