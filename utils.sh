# Check for existing keys
declare -a keys

existing_key(){
check=$(gpg --list-secret-keys --keyid-format=long|awk /sec/|wc -l)
keyno=$check
maxkeys=$check
while [ $check -gt 0 ];
do
	keys[check]=$(gpg --list-secret-keys --keyid-format=long|awk /sec/|cut -b 15-30|sed "${check}q;d")
	((check--))
done
};
	
# Exiting the program
ext(){
	echo
	echo "${bgWhite}${BLACK}                   ---------THANK YOU USING GPGKeygen---------                  ${RESET}"
}

# View all the existing keys
listkey(){
	    echo
		echo "${GREEN}Which key would you like to use?${RESET}"
		while [ $keyno -gt 0 ];
		do
			index=$((maxkeys+1-keyno))
			echo "${YELLOW}"$index - ${keys[keyno]}"${RESET}"
			((keyno--))
		done
}

# Adding the key to sign your commits
signcommit(){
	pskey=$1
	echo
	gpg --armor --export $pskey
	echo 
    echo "${RED}MAKE SURE YOU HAVE ADDED THE KEY TO YOUR GITHUB ACCOUNT BY:${RESET}"
    echo "${RED}=> Going to your github account at www.github.com${RESET}"
    echo "${RED}=> Going to your account settings${RESET}"
    echo "${RED}=> Going to SSH and GPG keys${RESET}"
    echo "${RED}=> Add new GPG key${RESET}"
    echo
    echo "${GREEN}Do you wish to add this key : ${RESET}"
    echo "${YELLOW}1. Globally - For all further commits in any repository${RESET}"
    echo "${YELLOW}2. Locally -  For this particular repository${RESET}"
    echo "${RED}0. Exit${RESET}"
    echo
    read gpgans
    if [ $gpgans -eq 1 ];
    then
    	git config --global user.signingkey $pskey
    	echo "This key will be used to sign all your further commits."
    elif [ $gpgans -eq 2 ];
    then
    	git config user.signingkey $pskey
    	echo "This key will be used to sign the commits of this repository only."
    fi
}

# Ask what to do with the key you've chosen to work with
keywork(){
	arg=$1
	echo
	gpg --armor --export $arg
	echo
	echo "${GREEN}What do you wish to do with the key?${RESET}"
	echo "${YELLOW}1. Use this for your commits${RESET}"
	echo "${RED}0. Exit${RESET}"
	read sol
	if [ $sol -eq 1 ];
	then
		signcommit $arg
	fi
}
