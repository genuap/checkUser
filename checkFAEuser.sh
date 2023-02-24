#!/bin/bash
_FAEuserFile="FAEuser"
red=$(tput setaf 1)
reset=$(tput sgr0)

echo -e " #######    #    #######    #     # #     #  #####   ##### " 
echo -e "  #         # #   #          ##    # #     # #     # #     #" 
echo -e "   #        #   #  #          # #   # #     # #             #" 
echo -e "    #####   #     # #####      #  #  # #     # #        #####"  
echo -e "     #       ####### #          #   # # #     # #       #"       
echo -e "      #       #     # #          #    ## #     # #     # #"       
echo -e "       #       #     # #######    #     #  #####   #####  #######"
echo

#check to see if FAE File exists
if [ -s "$_FAEuserFile" ] ; then
	file=$_FAEuserFile
	#file exists, so read username and timeframe
	while read -r user 
	do
		read -r timeframe
		username=$user
		echo 
	done <$file 
	echo "existing user: $username"
        echo "timestamp: $timeframe"
	echo
	
	current=$(date +"%Y%m%d%H%M%S")	
	if [ $current -le "$(echo "$timeframe")" ];
	#check to see if timestamp is expired or not	
	then
		#timestamp not expired
        	echo -e "${red}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${reset}"
        	echo -e "${red}The system is in use by: $username ${reset}"
        	echo -e "${red}until: $timeframe ${reset}"
        	echo -e "${red}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${reset}"
        	echo
        	echo "Contact $username before using this system!"
        	echo -e "Type ${red}$username ${reset} if you want to continue, anything else if you want to exit"
        	read -r
        	#if [[ "${REPLY}" == "$(cat ${_FAEuserFile})" ]] ; then
        	if [[ "${REPLY}" == "$username" ]] ; then
                	read -r -p "Please provide your name: "
                	echo "${REPLY}" > "${_FAEuserFile}"
   			read -r -p "How many hours do you want to reserve the system for: "
			echo $(date -d +${REPLY}\hour +%Y%m%d%H%M%S) >> "${_FAEuserFile}"
			exit	
		else
                	# send a SIGKILL signal to the to the script's parent process (the bash instance linked to the Terminal).
                	kill -9 $PPID
        	fi #response to name and hours
	else	
	#timestamp is expired, so reservation allowed	
		echo "System Reservation Expired and the system is not in use:"
       		read -r -p "Please provide your name: "
       		echo
       		echo "Your name will be displayed when someone logs in."
       		echo "This will not prevent anyone to take over the system."
       		echo "${REPLY}" > "${_FAEuserFile}"
   		read -r -p "How many hours do you want to reserve the system for: "
		echo $(date -d +${REPLY}\hour +%Y%m%d%H%M%S) >> "${_FAEuserFile}"
	fi #time le timestamp
	
else #file exists


echo "The system is not in use:"
read -r -p "Please provide your name: "
echo
echo "Your name will be displayed when someone logs in."
echo "This will not prevent anyone to take over the system."
echo "${REPLY}" > "${_FAEuserFile}"
read -r -p "How many hours do you want to reserve the system for: "
echo $(date -d +${REPLY}\hour +%Y%m%d%H%M%S) >> "${_FAEuserFile}"


fi #file exists

