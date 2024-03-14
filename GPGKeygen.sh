#!/bin/bash

source utils.sh

echo "---------WELCOME TO GPGKeygen---------"

declare -a keys

existing_key
if [ $keyno -lt 0 ];
then
	echo "There are no keys associated with this account. Do you wish to : "
	echo "1. Set up a new key"
	echo "0. Exit"
else
	echo "There are $keyno key-s linked to this account. Do you wish to : "
	echo "1. Set up a new key"
	echo "2. Work with an existing key"
	echo "0. Exit"
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