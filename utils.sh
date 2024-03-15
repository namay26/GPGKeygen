# Check for existing keys
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
	echo "----------THANK YOU USING GPGKeygen----------"
}

# View all the existing keys
listkey(){
		echo "Which key would you like to use?"
		while [ $keyno -gt 0 ];
		do
			index=$((maxkeys+1-keyno))
			echo $index - ${keys[keyno]}
			((keyno--))
		done
}

# Adding the key to sign your commits
signcommit(){
	pskey=$1
	gpg --armor --export $pskey
	echo 
    echo "MAKE SURE YOU HAVE ADDED THE KEY TO YOUR GITHUB ACCOUNT BY:"
    echo "=> Going to your github account at www.github.com"
    echo "=> Going to your account settings"
    echo "=> Going to SSH and GPG keys"
    echo "=> Add new GPG key"
    echo
    echo "Do you wish to add this key : "
    echo "1. Globally - For all further commits in any repository"
    echo "2. Locally -  For this particular repository"
    echo "0. Exit"
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
    else
    	ext
    fi
}

# Ask what to do with the key you've chosen to work with
keywork(){
	arg=$1
	echo "What do you wish to do with the key?"
	echo "1. Access the public key"
	echo "2. Use this for your commits"
	echo "0. Exit"
	read sol
	if [ $sol -eq 1 ];
	then
		gpg --armor --export $arg
	elif [ $sol -eq 2 ];
	then
		signcommit $arg
	else
		ext	
	fi
}