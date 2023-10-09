#!/bin/bash

# Storyline: Script to add and delte VPN peers

while getopts 'hdau:' OPTION ; do
	
	case "$OPTION" in
		
		d) u_del=${OPTION}
		;;
		a) u_add=${OPTION}
		;;
		u) t_user=${OPTARG}
		;;
		h)
			echo ""
			echo "Usage: $(basename $0) [-a]|[-d] -u username"
			echo ""
			exit 1
		
		;;
		*)
			echo ""
			echo "Invalid Value."
			echo ""
			exit 1
		;;
	esac

done

# Check to see if the -a and -d are empty or if they are both specified throw an error
if [[ ( ${u_del} == "" && ${u_add} == "") || ( ${u_del} != "" && ${u_add} != "" ) ]]
then
	echo ""
	echo "Please specify EITHER -a or -d and the -u and username."
	echo ""
fi

# Check to make sure that -u is specified
if [[ ( ${u_del} != "" || ${u_add} != "") && ${t_user} == "" ]]
then
	echo ""
	echo "Please specify a user (-u)!:"
	echo "Usage: $(basename $0) [-a][-d] [-u username]"
	echo ""
	exit 1
fi

# Delete a user!
if [[ ${u_del} ]]
then
	echo ""
	echo "Deleting user..."
	echo ""

	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

# Add a user!
if [[ ${u_add} ]]
then
	echo ""
	echo "Creating the User..."
	echo ""
	bash peer.bash ${t_user}
fi
