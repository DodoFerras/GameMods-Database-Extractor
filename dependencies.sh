#!/bin/bash

#Author Github:   https://github.com/g666gle
#Author Twitter:  https://twitter.com/g666gle1
#Date: 2/18/2019
#Usage: ./dependencies.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

if [ "${PWD##*/}" == "BaseQuery" ];then
	sudo chmod 755 -R $(pwd)
	sudo apt-get update -y
	sudo apt-get install python3.7 -y
	sudo apt-get install tar -y
	sudo apt-get install zstd -y
	sudo apt-get install xterm -y
	echo
	printf "${GREEN}[+]${NC} Finished downloading!\n"
else
	printf "${RED}ERROR: Please change directories to the BaseQuery root directory${NC}\n"
fi
