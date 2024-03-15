#!/bin/bash

source utils.sh

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
bgWhite="$(tput setb 7)";

clear
echo "${bgWhite}${BLACK}                     ---------WELCOME TO GPGKeygen---------                     ${RESET}"
echo 
existing_key
if [ $keyno -eq 0 ];
then
	echo "${GREEN}There are no keys associated with this account. Do you wish to : ${RESET}"
	echo "${BLUE}1. Set up a new key${RESET}"
	echo "${RED}0. Exit${RESET}"
else
	echo "${GREEN}There are $keyno key-s linked to this account. Do you wish to : ${RESET}"
	echo "${BLUE}1. Set up a new key${RESET}"
	echo "${YELLOW}2. Work with an existing key${RESET}"
	echo "${RED}0. Exit${RESET}"
fi
echo "----------------------------------"
read ans

if [ $ans -eq 1 ];
then
	makekey=$(gpg --full-gen-key)
	existing_key
	newkey=${keys[keyno]}
	keywork ${newkey}
	ext
elif [ $ans -eq 2 ];
then
	listkey
	read whckey
	oldkey=${keys[maxkeys-whckey+1]}
	keywork $oldkey
	ext
else
	ext
fi