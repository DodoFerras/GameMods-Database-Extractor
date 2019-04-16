#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 1/29/2019
#Usage: ./search.sh test@example.com <optional filename>
#Usage: ./search.sh test@ <optional filename>
#Usage: ./search.sh @example.com <optional filename>


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# Makes sure the user is in the BaseQuery dir
if [ "${PWD##*/}" == "BaseQuery" ];then
	# Grab everything before the @ sign
	user_name=$(echo "$1" | cut -d @ -f 1 | awk '{print tolower($0)}')
	email=$(echo "$1" | cut -d : -f 1 | awk '{print tolower($0)}')
	check_for_at=${1:0:1}

	# Check to see if the user entered in a domain ex) @google.com
	if [ "$check_for_at" == "@" ];then
		read -p "Are you sure you want to find every possible $1 address? This might take a while! [y/n] " answer
		# Checks input
		while [[ "$answer" != [YyNn] ]];do
			printf "${YELLOW}[!]${NC} Please enter either \"y\" or \"n\"!\n"
			read -p "Are you sure you want to find every possible $1 address? This might take a while! [y/n] " answer
		done
		if [[ "$answer" == [Yy] ]];then	# Checks if the user is sure
			read -p "Output to a file? [y/n] " out_to_file 
			# Checks input
			while [[ "$out_to_file" != [YyNn] ]];do
				printf "${YELLOW}[!]${NC} Please enter either \"y\" or \"n\"!\n"
				read -p "Output to a file? [y/n] " out_to_file 
			done
			# Decompress all files
			printf "${GREEN}[+]${NC} Decompressing files\n"
			./decompress.sh
			
			printf "${GREEN}[+]${NC} Starting search!\n"
			if [[ "$out_to_file" == [Yy] ]];then
				if ! [ -d ./OutputFiles ];then
					mkdir OutputFiles
				fi
				printf "${GREEN}[+]${NC} Outputting all results to ${GREEN}./OutputFiles/$1_output.txt${NC}\n"
				printf "${GREEN}[+]${NC} Please wait this could take a few minutes!\n"
			fi
			# Start iterating through every file in the database and grep for the domain name
			for first_nest_dir in data/*;do # data/0
				# More efficient than executing this statement twice in the if statement
				check="$(echo $first_nest_dir | cut -f 2 -d "/")"  
				# checks to see if the dir is not 0UTLIERS or NOTVALID
				if [[ "$(ls -A $first_nest_dir)" ]];then
					if [[ $check != "0UTLIERS" && $check != "NOTVALID" ]];then 
						for second_nest_dir in $first_nest_dir/*;do # data/0/0
							if [[ "$(ls -A $second_nest_dir)" ]];then
								# checks to see if the dir is 0UTLIERS and if the second dir is not empty
								if [[ "$(echo $second_nest_dir | cut -f 3 -d "/")" != "0UTLIERS" ]];then  
									for third_nest_dir in $second_nest_dir/*;do # data/0/0/0
										# checks to see if the dir is 0UTLIERS and if the third dir is not empty
										if [[ "$(ls -A $third_nest_dir)" ]];then 
											if [[ "$(echo $third_nest_dir | cut -f 4 -d "/")" != "0UTLIERS" ]];then 
												for fourth_dir in $third_nest_dir/*;do # data/0/0/0/a.txt <Could be the last 0UTLIERS dir>
													# Check to see if we have the 0UTLIERS dir and if the fourth dir is not empty
													if [[ "$(ls -A $fourth_dir)" ]];then
														if [[ "$(echo $fourth_dir | cut -f 5 -d "/")" != "0UTLIERS" ]];then #  data/0/0/0/0UTLIERS/
															# Loop through the files in the dir and grep for the domain name
															cat ./"$fourth_dir" | grep -i "$1" | while read -r Line;do 
																user_name="$(echo $Line | cut -f 1 -d ":")"
																Password="$(echo $Line | cut -f 2- -d ":")"
																# check if the user wants the output to a file
																if [[ "$out_to_file" == [Yy] ]];then 
																	echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
																else # Send the output to the console
																	printf "$user_name${RED}:"$Password"${NC}\n"
																fi
															done
														else # If the fourth dir is 0UTLIERS dir
															# Iterate through each file in the 0UTLIER dir
															for file in $fourth_dir/*;do # data/0UTLIERS
																# Loop through the dir and grep for the domain name
																cat ./"$file" | grep -i "$1" | while read -r Line;do
																	user_name="$(echo $Line | cut -f 1 -d ":")"
																	Password="$(echo $Line | cut -f 2- -d ":")"
																	# check if the user wants the output to a file
																	if [[ "$out_to_file" == [Yy] ]];then 
																		echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
																	else # Send the output to the console
																		printf "$user_name${RED}:"$Password"${NC}\n"
																	fi
																done
															done
														fi #fourth
													fi
												done
											else # If the third dir is 0UTLIERS dir
												# Iterate through each file
												for file in $third_nest_dir/*;do # data/0UTLIERS
													# Loop through the dir and grep for the domain name
													cat ./"$file" | grep -i "$1" | while read -r Line;do
														user_name="$(echo $Line | cut -f 1 -d ":")"
														Password="$(echo $Line | cut -f 2- -d ":")"
														# check if the user wants the output to a file
														if [[ "$out_to_file" == [Yy] ]];then 
															echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
														else # Send the output to the console
															printf "$user_name${RED}:"$Password"${NC}\n"
														fi
													done
												done
											fi # third
										fi
									done
								else # If the second dir is 0UTLIERS dir
									# Iterate through each file
									for file in $second_nest_dir/*;do # data/0UTLIERS
										# Loop through the dir and grep for the domain name
										cat ./"$file" | grep -i "$1" | while read -r Line;do
											user_name="$(echo $Line | cut -f 1 -d ":")"
											Password="$(echo $Line | cut -f 2- -d ":")"
											# check if the user wants the output to a file
											if [[ "$out_to_file" == [Yy] ]];then 
												echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
											else # Send the output to the console
												printf "$user_name${RED}:"$Password"${NC}\n"
											fi
										done
									done
								fi # second
							fi
						done
					else # If the first dir is 0UTLIERS dir
						# Iterate through each file
						for file in $first_nest_dir/*;do # data/0UTLIERS
							# Loop through the dir and grep for the domain name
							cat ./"$file" | grep -i "$1" | while read -r Line;do
								user_name="$(echo $Line | cut -f 1 -d ":")"
								Password="$(echo $Line | cut -f 2- -d ":")"
								# check if the user wants the output to a file
								if [[ "$out_to_file" == [Yy] ]];then 
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
								else # Send the output to the console
									printf "$user_name${RED}:"$Password"${NC}\n"
								fi
							done
						done					
					fi # first
				fi
			done
		else
			printf "${YELLOW}[!]${NC} Aborting!\n"
		fi
		
		printf "${YELLOW}[!]${NC} Finished search!\n"
		exit #end and exit	
	fi # End of checking for domain

	#########################################################################
	# The above code deals with querying every file for a specific domain	#
	# The below code deals with querying a specific username or file	#
	#########################################################################

	# Deals with all the cases of having a file vs stdin
	out_to_file="N"
	#  Check to see if the user is running a file or just commandline input
	if [ $# -ge 2 ];then
		out_to_file="YF" # Yes implicit from entering a file
	else  # The user is not running a file so ask them if they want to output to a file
		read -p "Output to a file? [y/n] " out_to_file 
		# Checks input
		while [[ "$out_to_file" != [YyNn] ]];do
			printf "${YELLOW}[!]${NC} Please enter either \"y\" or \"n\"!\n"
			read -p "Output to a file? [y/n] " out_to_file 
		done
		# Informing the user
		printf "${GREEN}[+]${NC} Starting search!\n"
		if [[ "$out_to_file" == [Yy] ]];then
			# Make the dir if it doesn't exist
			if ! [ -d ./OutputFiles ];then
				mkdir OutputFiles
			fi
			printf "${GREEN}[+]${NC} Outputting all results to ${GREEN}./OutputFiles/$1_output.txt${NC}\n"
		fi
	fi


	#  Check to make sure the user name is at least 4 and the email has a @
	if [[ ${#user_name} -ge 4 ]] && [[ "$email" == *"@"* ]];then	
		# Grab each individual character
		first_char=${user_name:0:1}  # {variable name: starting position : how many letters}
		second_char=${user_name:1:1}
		third_char=${user_name:2:1}
		fourth_char=${user_name:3:1}
		
		#  Check to see if the folder is compressed
		if [ -e ./data/"$first_char".tar.zst ];then
			#  Decompress the data
			#printf "${YELLOW}[!]${NC} Decompressing ./data/"$first_char".tar.zst\n"
			./decompress.sh "$first_char".tar.zst > /dev/null
			#printf "${GREEN}[+]${NC} Finished decompressing!\n"
			#printf "${GREEN}[+]${NC} Starting Search!\n"
			#echo
		fi

		#  Check the first directory
		if [ -d ./data/"$first_char" ];then
			#  Check the second directory
			if [ -d  ./data/"$first_char"/"$second_char" ];then
				#  Check the third directory
				if [ -d ./data/"$first_char"/"$second_char"/"$third_char" ];then
					if [[ "$out_to_file" == [Nn] ]];then
						printf "${GREEN}Email Address: "$email"${NC}\n"
					fi
					#  Check to see if the file exists
					if [ -e ./data/"$first_char"/"$second_char"/"$third_char"/"$fourth_char".txt ];then
						#  Open the file and search for the email address then only keep the passwords, iterate through the passwords and echo then
						cat ./data/"$first_char"/"$second_char"/"$third_char"/"$fourth_char".txt | grep -i "^$email" | while read -r Line;do
							user_name="$(echo $Line | cut -f 1 -d ":")"
							Password="$(echo $Line | cut -f 2- -d ":")"
							# check if the user wants the output to a file
							if [[ "$out_to_file" == [Yy] ]];then 
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
							elif [ "$out_to_file" == "YF" ];then
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
							else # Send the output to the console
								printf "$user_name${RED}:"$Password"${NC}\n"
							fi
						done
						
						#  Check to see if the email is in the NOT VALID file
						if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
							cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
								user_name="$(echo $Line | cut -f 1 -d ":")"
								Password="$(echo $Line | cut -f 2- -d ":")"
								# check if the user wants the output to a file
								if [[ "$out_to_file" == [Yy] ]];then 
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
								elif [ "$out_to_file" == "YF" ];then
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
								else # Send the output to the console
									printf "$user_name${RED}:"$Password"${NC}\n"
								fi
							done	
						fi
					else
						#  The file does not exists
						#  Check to make sure the directory exists and the file exists for 0UTLIERS
						if [[ -d ./data/$first_char/$second_char/$third_char/0UTLIERS && -e ./data/$first_char/$second_char/$third_char/0UTLIERS/0utliers.txt ]];then
							cat ./data/"$first_char"/"$second_char"/"$third_char"/0UTLIERS/0utliers.txt | grep -i "^$email" | while read -r Line;do
								user_name="$(echo $Line | cut -f 1 -d ":")"
								Password="$(echo $Line | cut -f 2- -d ":")"
								# check if the user wants the output to a file
								if [[ "$out_to_file" == [Yy] ]];then 
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
								elif [ "$out_to_file" == "YF" ];then
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
								else # Send the output to the console
									printf "$user_name${RED}:"$Password"${NC}\n"
								fi
							done	
						fi

						#  Check to see if the email is in the NOT VALID file
						if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
							cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
								user_name="$(echo $Line | cut -f 1 -d ":")"
								Password="$(echo $Line | cut -f 2- -d ":")"
								# check if the user wants the output to a file
								if [[ "$out_to_file" == [Yy] ]];then 
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
								elif [ "$out_to_file" == "YF" ];then
									echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
								else # Send the output to the console
									printf "$user_name${RED}:"$Password"${NC}\n"
								fi
							done	
						fi					
					fi
				else
					if [[ "$out_to_file" == [Nn] ]];then
						printf "${GREEN}Email Address: "$email"${NC}\n"
					fi
					#  The third letter directory does not exists
					if [[ -d ./data/$first_char/$second_char/0UTLIERS && -e ./data/$first_char/$second_char/0UTLIERS/0utliers.txt ]];then
						cat ./data/"$first_char"/"$second_char"/0UTLIERS/0utliers.txt | grep -i "^$email" | while read -r Line;do
							user_name="$(echo $Line | cut -f 1 -d ":")"
							Password="$(echo $Line | cut -f 2- -d ":")"
							# check if the user wants the output to a file
							if [[ "$out_to_file" == [Yy] ]];then 
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
							elif [ "$out_to_file" == "YF" ];then
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
							else # Send the output to the console
								printf "$user_name${RED}:"$Password"${NC}\n"
							fi
						done	
					fi

					#  Check to see if the email is in the NOT VALID file
					if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
						cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
							user_name="$(echo $Line | cut -f 1 -d ":")"
							Password="$(echo $Line | cut -f 2- -d ":")"
							# check if the user wants the output to a file
							if [[ "$out_to_file" == [Yy] ]];then 
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
							elif [ "$out_to_file" == "YF" ];then
								echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
							else # Send the output to the console
								printf "$user_name${RED}:"$Password"${NC}\n"
							fi
						done	
					fi
				fi
			else
				if [[ "$out_to_file" == [Nn] ]];then
					printf "${GREEN}Email Address: "$email"${NC}\n"
				fi
				#  The second letter directory does not exists
				if [[ -d ./data/$first_char/0UTLIERS && -e ./data/$first_char/0UTLIERS/0utliers.txt ]];then
					cat ./data/"$first_char"/0UTLIERS/0utliers.txt | grep -i "^$email" | while read -r Line;do
						user_name="$(echo $Line | cut -f 1 -d ":")"
						Password="$(echo $Line | cut -f 2- -d ":")"
						# check if the user wants the output to a file
						if [[ "$out_to_file" == [Yy] ]];then 
							echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
						elif [ "$out_to_file" == "YF" ];then
							echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
						else # Send the output to the console
							printf "$user_name${RED}:"$Password"${NC}\n"
						fi
					done	
				fi

				#  Check to see if the email is in the NOT VALID file
				if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
					cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
						user_name="$(echo $Line | cut -f 1 -d ":")"
						Password="$(echo $Line | cut -f 2- -d ":")"
						# check if the user wants the output to a file
						if [[ "$out_to_file" == [Yy] ]];then 
							echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
						elif [ "$out_to_file" == "YF" ];then
							echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
						else # Send the output to the console
							printf "$user_name${RED}:"$Password"${NC}\n"
						fi
					done	
				fi
			fi
		else
			if [[ "$out_to_file" == [Nn] ]];then
				printf "${GREEN}Email Address: "$email"${NC}\n"
			fi
			#  The first letter directory does not exists
			if [[ -d ./data/0UTLIERS && -e ./data/0UTLIERS/0utliers.txt ]];then
				cat ./data/0UTLIERS/0utliers.txt | grep -i "^$email" | while read -r Line;do
					user_name="$(echo $Line | cut -f 1 -d ":")"
					Password="$(echo $Line | cut -f 2- -d ":")"
					# check if the user wants the output to a file
					if [[ "$out_to_file" == [Yy] ]];then 
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
					elif [ "$out_to_file" == "YF" ];then
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
					else # Send the output to the console
						printf "$user_name${RED}:"$Password"${NC}\n"
					fi
				done	
			fi

			#  Check to see if the email is in the NOT VALID file
			if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
				cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
					user_name="$(echo $Line | cut -f 1 -d ":")"
					Password="$(echo $Line | cut -f 2- -d ":")"
					# check if the user wants the output to a file
					if [[ "$out_to_file" == [Yy] ]];then 
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
					elif [ "$out_to_file" == "YF" ];then
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
					else # Send the output to the console
						printf "$user_name${RED}:"$Password"${NC}\n"
					fi
				done	
			fi
		fi
	else  # If not a valid address
		first_char=${user_name:0:1}  # {variable name: starting position : how many letters}

		#  Check to see if the folder is compressed
		if [ -e ./data/"$first_char".tar.zst ];then
			./decompress.sh "$first_char".tar.zst > /dev/null
		fi
		#  Uncompresses NOTVALID
		if [ -e ./data/NOTVALID.tar.zst ];then
			./decompress.sh NOTVALID.tar.zst > /dev/null
		fi
		# Supreses output
		if [[ "$out_to_file" == [Nn] ]];then
			printf "${GREEN}Email Address: "$email"${NC}\n"
		fi

		# Checks if the email has an @ 
		if [[ $email == *"@"* ]];then
			#  The username is either not >= 4 or the email doesn't contain an @
			#  Check to see if the email is in the NOT VALID file
			if [[ -d ./data/NOTVALID && -e ./data/NOTVALID/FAILED_TEST.txt ]];then
				cat ./data/NOTVALID/FAILED_TEST.txt | grep -i "^$email" | while read -r Line;do
					user_name="$(echo $Line | cut -f 1 -d ":")"
					Password="$(echo $Line | cut -f 2- -d ":")"
					# check if the user wants the output to a file
					if [[ "$out_to_file" == [Yy] ]];then 
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$1"_output.txt
					elif [ "$out_to_file" == "YF" ];then
						echo  ""$user_name":"$Password"" >> ./OutputFiles/"$2"_output.txt
					else # Send the output to the console
						printf "$user_name${RED}:"$Password"${NC}\n"
					fi
				done	
			fi
		else
			printf "${YELLOW}[!]${NC} Please enter one email address or a file with one email address per line\n"
		fi
	fi

else
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
fi





