#!/bin/bash
#Author :- Quod Vide
#Created :- 24-12-2021

#A small script to change linux account passwords and some system info tweaks

#Check for  the number of user accounts available in a linux  system
#This script will not autodetect hidden accounts in a linux system

#This program is under serious construction


##SOme color definitions 
##Get script path from script name
script_name=`echo $0`
script_path=`echo "$0" |rev |cut -d '/' -f 2- |rev`
real_name=$(echo "$0" |rev  2> /dev/null|cut -d '/' -f 1 |rev)

declare  reset_f="\033[0m"
declare  green_f="\033[32m"
declare black_f="\033[30m"
declare yellow_f="\033[33m"
declare magenta_f="\033[35m"
declare white_f="\033[37m"
declare  dim="\033[2m"
declare italic="\033[3m"
declare  underline="\033[4m"
declare red_f="\033[31m"
declare reset="\033[0m"


##initilisation 
init(){
declare -i num=1
while (( num < 45 ))
do 
(( num++ ))
echo -ne "$magenta_f + $reset"
sleep 0.01
done
}

##Usable in the future

#banner


banner_main(){
	echo -e $yellow_f 

cat << "EOF"		
					 _     ___ _   _ _   ___  __   _______        _______    _    _  _______ ____  
					| |   |_ _| \ | | | | \ \/ /  |_   _\ \      / / ____|  / \  | |/ / ____|  _ \ 
					| |    | ||  \| | | | |\  /_____| |  \ \ /\ / /|  _|   / _ \ | ' /|  _| | |_) |
					| |___ | || |\  | |_| |/  \_____| |   \ V  V / | |___ / ___ \| . \| |___|  _ < 
					|_____|___|_| \_|\___//_/\_\    |_|    \_/\_/  |_____/_/   \_\_|\_\_____|_| \_\

					****************************************************************
					* Copyright of Quod Vide, 2021                	               *
					* https://www.github.com/emiliano445                 	       *
					* https://www.youtube.com/nameless_baby_                       *
					****************************************************************
						Version -: 1.00 Universal_Linux Compatible

EOF
echo -e $reset_f

}




user_check(){

#check_u=$(for check in $(getent passwd |grep home |awk -F: '{print $1}');do  echo $check;done)

if [[ -e "$PWD"/users_0.list ]]
then
	rm users_0.list #Remove file to avoid duplicates on each run
fi 

for check in $(getent passwd |grep home |awk -F: '{print $1}')
do
	for verify_account in "$check"
	do
		if [[ -d "/home/$verify_account" ]]
		then
			#printf "Verifying user account .... " |pv -qL 30
			#printf "User $verify_account exists\n"
			echo "${verify_account}" >> users_0.list
		fi

	done
done
printf "Done Verifying user accounts .... \n" |pv -qL 100 2>/dev/null
clear

#printf "$check_u"
#for verify_account in $check_u
#do
	#if [[ -d "/home/$verify_account" ]]
	#then
		#printf "Verifying user accounts ...." |pv -qL 30
		#printf "User $verify_account exists\n"
#	fi
#done

}

root_pass(){

pass="" #clear any variables that may contain content
red=`echo -e $red_f`
red_reset=`echo -e $reset_f`
read  -s -p "Input  new  password for $red'root'$red_reset [Atleast 7 characters long(Can't be  blank)]: " pass
echo
read -s -p "Confirm  new  password: " pass1 

#check if blank
if [[ -z "$pass" || -z "$pass1" ]] ##check if any of this var is blank
then
	ps2_red=$(echo -e "$red_f"'Error.. Password cannot be blank .. Choose an option to Proceed..' $magenta_f '>>' "$reset_f")
	PS3="$ps2_red"
	echo
	return_option=("Retry setting password again" "Back to Users Menu List" "Back to Main Menu")
	select option in "${return_option[@]}";do
	case "${option[@]}" in
		 "${return_option[0]}")root_pass;;
		 "${return_option[1]}")other_user_select;;
		 "${return_option[2]}")menu;;
		 *)printf "Invalid option.. Please select from the list\n";
	esac
	done
	# echo "error.. Password cannot be blank" #Initial back to root only
	# start #Back to start ##Error back to root_pass
	# root_pass
# fi 
 elif [[  "$pass" != "$pass1" ]];then

#check match
# if [[  "$pass" -ne "$pass1" ]];then 
	echo -e "\n"$red_f"Passwords  don't  match\nOPTIONS"$reset_f""
	# while [ "$pass" -ne "$pass1" ]
	# do
		ps_red=$(echo -e "$yellow_f"'One of the passwords do not match.. Select an option to proceed: ' $cyan_f'>>'"$reset_f")
		PS3="$ps_red"
		echo
		return_option_a=("Retry setting password again" "Back to Users Menu List" "Back to Main Menu")
		select option_a in "${return_option_a[@]}";do
		case "${option_a[@]}" in
			 "${return_option_a[0]}")root_pass;;
			 "${return_option_a[1]}")other_user_select;;
			 "${return_option_a[2]}")menu;;
			 *)printf "Invalid option.. Please select from the list\n";
		esac
		done
		# start ##Goto start
		# root_pass ##The menu again no more loops

	# done

else 
    echo "Passwords match.."
    echo "Proceeding to change password."
fi

for input in  "${pass}" #Level pass || pass1 = same
#in1="$pass" ;echo "$in1" >pass  #deprecated   &insecure 
#in2="$pass" ;echo "$in2" >>pass  #deprecated &insecure 
do
	in1="${pass}"
	in2="${pass1}"

done 
#Run passwd command and set the password inserted by user
passwd root <  <(echo  -e ""$in1"\n"$in2"") && clear && echo "SUCCEDED... New  password set for user account " || echo "Password  change  failed"

}

other_user_change(){
if [[ -z "$user_account" ]];then ##means wrong input was parsed
	printf $red_f"Invalid USER option  was selected .. please Retry..\n"
	read -t 5 -n 1 -p "Press A KEY to RETRY ! . ."
	echo -e "$reset_f"
	other_user_select

fi
pass="" #clear any variables that may contain content
echo -e "$red_f"
read  -s -p "Input  new  password for account $user_account [Atleast 7 characterslong(Can't be  blank)]: " pass
echo -e "$reset_f"
echo -e "$red_f"
read -s -p "Confirm  new  password: " pass1 
echo -e $reset_f
#check if blank
if [[ -z $pass || -z $pass1 ]] ##check if any of this var is blank
then
	ps3_red=$(echo -e "$red_f"'Error.. Password cannot be blank .. Choose an option to Proceed..' "$reset_f")
	PS3="$ps3_red"
	echo
	return_option=("Retry setting password again" "Back to Users Menu List" "Back to Main Menu")
	select option in "${return_option[@]}";do
	case "${option[@]}" in
		"${return_option[0]}")other_user_change;;
		"${return_option[1]}")other_user_select;;
		"${return_option[2]}")menu;;
		 *)printf "Invalid option.. Please select from the list\n";
	esac
	done
	# echo "error.. Password cannot be blank"
	# start #Back to start ##Back to this function
	# other_user_change
fi

#check match
if [[  "$pass" != "$pass1" ]];then 
	echo "Passwords  don't  match"
	while [ "$pass" != "$pass1" ]
	do
		# start ##Back here
		# other_user_change same  check again
		ps_red=$(echo -e "$magenta_f"'One of the passwords do not match.. Select an option to proceed' "$reset_f")
		PS3="$ps_red"
		echo
		return_option_b=("Retry setting password again" "Back to Users Menu List" "Back to Main Menu")
		select option_b in "${return_option_b[@]}";do
		case "${option_b[@]}" in
			"${return_option_b[0]}")other_user_change;; #back here
			"${return_option_b[1]}")other_user_select;;
			"${return_option_b[2]}")menu;;
			 *)printf "Invalid option.. Please select from the list\n";
		esac
		done

	done

else 
    echo "Passwords match.."
    echo "Proceeding to change password."
fi


for input in  "${pass}" #Level pass || pass1 = same
#in1="$pass" ;echo "$in1" >pass  #deprecated   &insecure 
#in2="$pass" ;echo "$in2" >>pass  #deprecated &insecure 
do
	in1="${pass}"
	in2="${pass1}"

done 
#Run passwd command and set the password inserted by user
passwd "$user_account" <  <(echo  -e ""$in1"\n"$in2"") && clear && echo "SUCCEDED... New  password set for user account " || echo "Password  change  failed"

}


##Simple function change other user password
other_user_select(){
user_check #Run function to create file
list=$(cat users_0.list)
PS3="Select a user account: "
# recheck=$(echo $list)
select account in  $(echo $list) "Back To main menu" ##Error solve some added checks
do
	case "$account" in 
		"$account") if [[ "$account" == "Back To main menu" ]];then
																 menu ;
														   else 
														   	declare   user_account=$account;other_user_change;fi ;break;;
		


	esac
done

	# declare -g  user_account=$account #global
	# if ##No checks 
	# 	[[ -n $user_account ]]
	# then
	# 	clear
	# fi
	# other_user_change
	#other_user_change
	#passwd $account
	# break #Don't get stuck in this loop
# done

}


###server actions 
server_localhost_run(){
local  plr=""
printf "This performs a port forwarding to a specified port on your pc\n"
# printf "$underline localhost.run is the website to be used $reset_f"
read -p "Forward traffic to port? You can press 'x' to return to previus menu. [default 80 (Apache2 web server)]" plr
if [[ -z $plr ]]
then
	 plr=80 #Auto set to 80 if blank
# elif [[ $portl -ne [0-9][0-9] || $portl -ne [0-9][0-9][0-9] || $portl -ne [0-9][0-9][0-9][0-9] || $portl -ne [0-9][0-9][0-9][0-9][0-9]  || $portl -ne [0-9] [0-9] [0-9][0-9][0-9][0-9] ]];then
 # else	#printf $green"Error ... Please enter a port number 'two' to 'six digits'\n" $reset_f
##Check if integer
elif [[ -n $plr ]];then
	if [[ ! $plr =~  ^[+-]?[0-9]{1,6}+$  ]];then
		if [[ $plr == x ]]; then net_tasks;else printf "Wrong port format/Input entered. Re-enter or press 'x' to go back to previus menu.\n";server_localhost_run;fi;fi
# else #No more else
	##forward traffic

fi

printf "Port forward started: .. Forwarding traffic to port $portl\n"
xterm -geometry 124x27 -T 'PORT FORWARD VIA LOCALHOST.RUN' -hold -e ssh -R 80:localhost:$plr localhost.run &

echo -e "$cyan_f"
read -n1 -p "Press any key to go back to menu -:"
echo -e "$reset_f"		
# case $portl in
# 	[0-9][0-9])echo $portl;;
# 	[0-9][0-9][0-9])echo $portl;;
# 	[0-9][0-9][0-9][0-9])echo $portl;;
# 	[0-9][0-9][0-9][0-9][0-9])echo $portl;;
# 	[0-9][0-9][0-9][0-9][0-9][0-9])echo $portl;
# 		;;
# esac

# ssh_forward #back to here
}

####Network tasks  function calls

ssh_forward(){
	echo -e "$white_f"
PS3="SELECT A SERVER TO PROCEED: --> "
array_port_forward_servers=("localhost.run" "server_name2" "Back to previus menu")
select server_name in "${array_port_forward_servers[@]}";do
	case "$server_name" in 
			"${array_port_forward_servers[0]}")server_localhost_run;break;; #goto this function and perform action
			"${array_port_forward_servers[1]}")echo null;;
			"${array_port_forward_servers[2]}")net_tasks;;
			 *)printf "Invalid option.. Please select from the list\n";
	esac

done
echo -e "$reset_f"
}


###Local chatroom start
local_chatroom_start(){
listen_port=""
read -p "Enter port to listen on or press 'x' to go back to previus menu [default port  50008]-:>> " listen_port
echo
if [[ -z $listen_port ]];then #validate this port input
	listen_port=50008
elif [[ -n $listen_port ]]; then
	if [[ ! $listen_port =~ ^[+-]?[0-9]+$ ]]; then #CHECK IF STRING
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $listen_port == x ]]; then
			#statements
			chat_room_option
		else
			printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
			local_chatroom_start

		fi
		
	fi
	# #statements
	# if [[ $listen_port =~ ^[+-]?[0-9]+$ ]]; then
	# 	case $listen_port in
	# 		[0-9])valid_port=$listen_port;;
	# 		[0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9][0-9][0-9])echo "Invalid port range number Port number must be from '1-6'";local_chatroom_start;
	# 	esac
	# fi	


##Ignore never gets read
else
	printf "Enter a valid port number\n"


fi

printf "Valid port number entered .. proceeding\n"
xterm -geometry 124x27 -T 'Chat Room [nc server]' -hold -e  nc -lvp $listen_port &
xterm -geometry 124x27 -T 'Chat Room Connect And Reply [connect client]' -hold -e  nc 127.0.0.1 $listen_port &
printf "Nc is working on port $listen_port\n"
echo -e "$green_f"
printf "Chatroom Started\n"
echo -e "$reset_f"
read -n1 -p "Press any key to go back to menu -:"
echo
}


##local chat room with shell control

local_with_shell_start(){
listen_port=""
read -p "Enter port to listen on or press 'x' to go back to previus menu [default port  50009]-:>> " listen_port
echo
if [[ -z $listen_port ]];then #validate this port input
	listen_port=50009
elif [[ -n $listen_port ]]; then
	if [[ ! $listen_port =~ ^[+-]?[0-9]+$ ]]; then #CHECK IF integer
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $listen_port == x ]]; then
			#statements
			chat_room_option
		else
			printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
			local_chatroom_start

		fi
		
	fi
	# #statements
	# if [[ $listen_port =~ ^[+-]?[0-9]+$ ]]; then
	# 	case $listen_port in
	# 		[0-9])valid_port=$listen_port;;
	# 		[0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9][0-9])valid_port=$listen_port;;
	# 		[0-9][0-9][0-9][0-9][0-9][0-9][0-9])echo "Invalid port range number Port number must be from '1-6'";local_chatroom_start;
	# 	esac
	# fi	


##Ignore
else
	printf "Enter a valid port number\n"


fi

printf "Valid port number entered .. proceeding\n"
echo -e "To run a local shell with command execution ncat is required... $red_f checking requirement ... $reset_f";sleep 2
ncat --help 1>/dev/null
if [[ $? -ne 0 ]]; then
	echo "Seems you have not installed netcat"
read -p "Would you like to install it now ? [ Y / N ]" ans
echo
if [[ $ans == Y ]]; then
	#statements
	xterm -geometry 124x27 -T 'Install ncat requirement' -hold -e  apt install ncat &
elif [[ $ans == N ]]; then
	echo "Returning back to menu ... This option will be available when you install $red_f ncat$reset_f"
	chat_room_option
fi
else
	echo -e $cyan_f"GREAT :) Netcat is installed.. proceeding "$reset_f

fi
xterm -geometry 124x27 -T 'Chat Room SHELL SERVER_' -hold -e  ncat -lvp $listen_port -e /bin/bash &
xterm -geometry 124x27 -T 'Chat Room Connect 2 SHELL' -hold -e  ncat localhost $listen_port &
printf "Netcat is working on port $listen_port\n"
echo -e "$green_f"
printf "Chatroom Started\n"
echo -e "$reset_f"
read -n1 -p "Press any key to go back to menu -: "
echo
}


##remote chatroom
host_raw_rcm_function(){
local iface=""
local final_i=""
local ans_iface=""
local ip_get=""
local _listen_port=""
local parse=""
local ans=""
###Logic the program cannot be continuing with wrong values
read -p "Use interface name?? wlan0/ eth0 [wlan0 by default] Press 'x' to go back to previus menu:" iface
echo
if [[ -z $iface  ]];then
	iface=wlan0
	final_i=$iface
elif [[  $iface == wlan0  ]];then
	ans_iface=$iface
	final_i=$ans_iface
elif [[ $iface == eth0 ]];then
	ans_iface=$iface
	final_i=$ans_iface
elif [[  $iface == x  ]];then
	chat_room_option
else
	printf "Wrong interface specified\n"
read -p "Re-enter interface name or ENTER TO DEFAULT TO wlan0 OR  press 'x' to cancel and get back to previus option -: >> " parse
# while [[ $parse == x ]];do
# 	chat_room_option
# done	
# while [[  $parse == wlan0 || $parse == eth0 ]];do
# 	iface=$parse
# 	final_i=$iface
# done
while [[ $parse == "" ]];do final_i=wlan0;break;done
while [[ $parse == wlan0 || $parse == eth0 ]];do final_i=$parse;break;done
while [[ $parse == x ]];do chat_room_option;break;done
while [[ ! parse == "" || ! $parse == wlan0 || ! $parse == eth0 || ! parse == x  ]];do echo -e  "$red_f INVALID OPTION SUPPLIED ..BACK TO MENU ... $reset_f" ;host_raw_rcm_function;break;done



fi	


##proceed
ip_get=`ifconfig $final_i |grep inet |grep netmask |awk -F " " '{print $2}'` ##wlan0 and eth0 both have the same format in ip addressing

_listen_port=""
read -p "Enter port to listen on or press 'x' to cancel and  go back to previus menu [default port  50001]-:>> " _listen_port
echo
if [[ -z $_listen_port ]];then #validate this port input
	_listen_port=50001
elif [[ -n $_listen_port ]]; then
	if [[ ! $_listen_port =~ ^[+-]?[0-9]+$ ]]; then #CHECK IF integer
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $_listen_port == x ]]; then
			#statements
			chat_room_option
		else
			printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
			host_raw_rcm_function

		fi
		
	fi

fi

echo -e "To Host a secure shell even to chat  ncat is required... $red_f checking requirement ... $reset_f";sleep 2
ncat --help 1>/dev/null
if [[ $? -ne 0 ]]; then
	echo "Seems you have not installed netcat"
read -p "Would you like to install it now ? [ Y / N ]" ans
echo
if [[ $ans == Y ]]; then
	#statements
	xterm -geometry 124x27 -T 'Install ncat requirement' -hold -e  apt install ncat &
elif [[ $ans == N ]]; then
	echo "Returning back to menu ... This option will be available when you install $red_f ncat$reset_f"
	chat_room_option
fi
else
	echo -e $cyan_f"GREAT :) Netcat is installed.. proceeding "$reset_f

fi
xterm -geometry 124x27 -T 'Chat Room Remote SHELL SERVER_' -hold -e  ncat -lvp $_listen_port &
printf "Netcat is working on port $_listen_port\n"
echo -e "$green_f"
printf "Remote Chatroom Server Started\n"
printf "Issue This command to the other remote computer : 'ncat' $ip_get $_listen_port\nGot this ipaddress from interface $final_i"
echo -e "$reset_f"
read -n1 -p "Press any key to go back to menu -: "
echo

# if [[ $iface != wlan0 || $iface != eth0  ]];then
# printf "Wrong Interface specified\n"
# printf "Press enter to default to wlan0 or enter a valid interface name with internet connection\n"
# host_server_start
# elif [[ -n $iface ]];then
# 	if [[ $iface == wlan0 || $iface == eth0 ]];then
# 		ans_iface=$iface
# 		ip=`ifconfig $ans_iface |grep inet |awk -F " " '{print $2}'`
# 		read -p "Enter port Range of one to six digits: [Default is 8765 ]" ip_port
# 		if [[ -z $ip_port ]];then
# 			ip_port=8765
# 		elif [[ ! $ip_port  =~ ^[+-]?[0-9]+$ ]]; then
# 			printf "Invalid port number entered ....Repeat process..\n"
# 			host_server_start
# 		fi
# 	printff "Starting server on ip $ip \n Running on Port "
	
	
		
	
# 		#statements
		
# 	fi
# fi	

}

##remote shell



host_rcm_with_shell_function(){

local iface=""
local final_i=""
local ans_iface=""
local ip_get=""
local _listen_port=""
local parse=""
local ans=""
###Logic the program cannot be continuing with wrong values
read -p "Use interface name?? wlan0/ eth0 [wlan0 by default] Press 'x' to go back to previus menu:" iface
echo
if [[ -z $iface  ]];then
	iface=wlan0
	final_i=$iface
elif [[  $iface == wlan0  ]];then
	ans_iface=$iface
	final_i=$ans_iface
elif [[ $iface == eth0 ]];then
	ans_iface=$iface
	final_i=$ans_iface
elif [[  $iface == x  ]];then
	chat_room_option
else
	printf "Wrong interface specified\n"
read -p "Re-enter interface name or ENTER TO DEFAULT TO wlan0 OR  press 'x' to cancel and get back to previus option -: >> " parse
# while [[ $parse == x ]];do
# 	chat_room_option
# done	
# while [[  $parse == wlan0 || $parse == eth0 ]];do
# 	iface=$parse
# 	final_i=$iface
# done
while [[ $parse == "" ]];do final_i=wlan0;break;done
while [[ $parse == wlan0 || $parse == eth0 ]];do final_i=$parse;break;done
while [[ $parse == x ]];do chat_room_option;break;done
while [[ ! parse == "" || ! $parse == wlan0 || ! $parse == eth0 || ! parse == x  ]];do echo -e  "$red_f INVALID OPTION SUPPLIED ..BACK TO MENU ... $reset_f" ;host_raw_rcm_function;break;done



fi	


##proceed
ip_get=`ifconfig $final_i |grep inet |awk -F " " '{print $2}'` ##wlan0 and eth0 both have the same format in ip addressing

_listen_port=""
read -p "Enter port to listen on or press 'x' to cancel and  go back to previus menu [default port  50001]-:>> " _listen_port
echo
if [[ -z $_listen_port ]];then #validate this port input
	_listen_port=50001
elif [[ -n $_listen_port ]]; then
	if [[ ! $_listen_port =~ ^[+-]?[0-9]+$ ]]; then #CHECK IF integer
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $_listen_port == x ]]; then
			#statements
			chat_room_option
		else
			printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
			host_raw_rcm_function

		fi
		
	fi

fi

echo -e "To Host a secure Reverse shell or  even to chat  ncat is required... $red_f checking requirement ... $reset_f";sleep 2
ncat --help 1>/dev/null
if [[ $? -ne 0 ]]; then
	echo "Seems you have not installed netcat"
read -p "Would you like to install it now ? [ Y / N ]" ans
echo
if [[ $ans == Y ]]; then
	#statements
	xterm -geometry 124x27 -T 'Install ncat requirement' -hold -e  apt install ncat &
elif [[ $ans == N ]]; then
	echo "Returning back to menu ... This option will be available when you install $red_f ncat$reset_f"
	chat_room_option
fi
else
	echo -e $cyan_f"GREAT :) Netcat is installed.. proceeding "$reset_f

fi
xterm -geometry 124x27 -T $red_f"Chat Room Remote Reverse Command HOSTED SHELL SERVER_"  -hold -e  ncat -lvp $_listen_port -e /bin/bash &
echo -e "$reset_f"
printf "Netcat is working on port $_listen_port\n"
echo -e "$green_f"
printf "Remote Chatroom Server and Command Controller Started\n"
printf "Issue This command to the other remote computer : 'ncat' $ip_get $_listen_port\nGot this ipaddress from interface $final_i"
echo -e "$reset_f"
echo -e $red_f
printf "WARNING THIS IS A HOSTED REVERSE SHELL YOU STARTED .. BE WARE OF COMMANDS AND OPERATIONS PERFORMED ON THIS MACHINE FROM THE OTHER END ! ! (:-" $reset_f
read -n1 -p "Press any key to go back to menu -: "
echo -e "$reset_f"
echo



}



join_remote_chat_room(){
read -p "Enter ip address to connect to or press 'x' to go back to main chat room option [Default is 0.0.0.0 (loop back 127.0.0.1)]" connect_ip
echo
if [[ -z $connect_ip ]];then #validate this port input
	connect_ip=127.0.0.1
elif [[ -n $connect_ip ]]; then
	if [[ ! $connect_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}+$  ]]; then #CHECK IF input is a 
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $connect_ip == x ]]; then
			#statements
			chat_room_option
		else
			printf "Enter a valid ip address or enter 'x' to go back to previus menu \n" 
			join_remote_chat_room

		fi
		
	fi

fi

connect_port=""
read -p "Enter port to connect to  or press 'x' to cancel and  go back to main chat room [default port  9990]-:>> " connect_port
echo
if [[ -z $connect_port ]];then #validate this port input
	connect_port=9990
elif [[ -n $connect_port ]]; then
	if [[ ! $connect_port =~ ^[+-]?[0-9]{1,6}+$ ]]; then #CHECK IF integer
		# printf "Enter a valid port number from '0-1-6 or enter 'x' to go back to previus menu \n" 
		if [[ $connect_port == x ]]; then
			#statements
			chat_room_option
		else
			printf $red_f"[-] Enter a valid port number  ' 'maximum of six digits' or enter 'x' to go back to previus menu \n" $reset_f
			join_remote_chat_room #Back to this function

		fi
		
	fi

fi
printf $green_f"Initialising remote connection to $connect_ip on port $connect_port\n"$reset_f
xterm -geometry 124x27 -T "^@^ESTABLISHING CONNNECTION TO A REMOTE CHAT ROOM . . ."  -hold -e  ncat  $connect_ip $connect_port &
read -n1 -p "Press any key to go back to chatRoom menu -: "
chat_room_option
echo
}

##Chat room option ##local/remote
chat_room_option(){
echo -e $white_f
PS3="You can choose a local, "local_with_shell", 'host_raw_remote_chat room' or "host_remote_chat_room+shell" "Join_remote_chat_room" option -: >> " 
select option in "Local" "Local_shell" "host_raw_rcm" "host_rcm_with_shell" "Join_remote_chat_room" "Back";do
	case "$option" in 
		"Local")local_chatroom_start;break;;
		"Local_shell")local_with_shell_start;;
		"host_raw_rcm")host_raw_rcm_function;;
		"host_rcm_with_shell")host_rcm_with_shell_function;;
		"Join_remote_chat_room")join_remote_chat_room;;
		"Back")net_tasks;; #Call previus
		 *)printf "Invalid option.. Please select from the list\n";
	esac
done
echo -e reset_f
}

#evil  starthe
evil_start(){
printf $yellow_f"Cheking  if Evillimiter is installed\n" $reset_f
evillimiter -h > /dev/null 2>/dev/null
if [[ $? -eq 0 ]];then
	printf $white_f"Evillimiter is  already installed..Starting it for you as a background job \n"$reset_f
	# gnome-terminal -e evillimiter&
	gnome-terminal -e "bash -c evillimiter --flush"& #bg job

else
	echo "Evillimiter not installed,Installing it for you!"
	echo "Installing evillimiter-master...It will automatically start if installation succeeds"
	# xterm -geometry 124x27 -T "^Evillimiter installation !"  -hold -e echo "$script_path"&
	xterm -geometry 124x27 -T "^Evillimiter installation !"  -hold -e "cd "$script_path"/pkgs_00/evillimiter-master/ && python3 setup.py install&&gnome-terminal -e 'bash -c evillimiter --flush'"&
	printf $red_f"Be patient till installation  completes.When complete,Evillimiter will be launched automatically!\n"$reset
fi
}
#evil end




##Net tasks
net_tasks(){
echo -e "$magenta_f"
PS3="Select a network option to proceed -: >> "
network_tasks=("Free SSH Port Forward" "Start/Join a chat room Local/[WI-FI]" "Run Evillimiter" "Back To Previus Options") ##chat room local/remotely ##Can append later during development
select task in "${network_tasks[@]}";do
	case "${task[@]}" in
		"${network_tasks[0]}")ssh_forward;;
		"${network_tasks[1]}")chat_room_option;;
		"${network_tasks[2]}")evil_start;;
		"${network_tasks[3]}")more_options;;
		 *)printf "Invalid option.. Please select from the list\n";

		

	esac	
done




echo -e "$reset_f"
}



local_tasks(){

echo -e  $red_f"This sector of the program is under serious construction\nSelect another option please"$reset_f

}



##The linux timer program integrated inside here
linux_timer(){
##variables to be used only within this function
local reset_f="\033[0m"
local green_f="\033[32m"
local black_f="\033[30m"
local  yellow_f="\033[33m"
local magenta_f="\033[35m"
local white_f="\033[37m"
local dim="\033[2m"
local italic="\033[3m"
local underline="\033[4m"
local red_f="\033[31m"
local reset="\033[0m"
local cyan_f="\033[36m"



banner_lx(){
echo -e  $yellow_f 
cat << "EOF1"
		  ____                                          _ _____ _                     
		 / ___|___  _ __ ___  _ __ ___   __ _ _ __   __| |_   _(_)_ __ ___   ___ _ __ 
		| |   / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` | | | | | '_ ` _ \ / _ \ '__|
		| |__| (_) | | | | | | | | | | | (_| | | | | (_| | | | | | | | | | |  __/ |   
		 \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_| |_| |_|_| |_| |_|\___|_|   
		                                                                              
		****************************************************************
		* Copyright of 	Quod Vide, 2021                                *
		* https://www.github.com/3mili@no445                           *
		* https://www.youtube.com/nameless_boy_                        *
		****************************************************************

																					
EOF1
echo -e "$reset"
}


#All inputs set only ready for count down 
calculate(){
if [[ $total_time -eq 0 ]];then printf "Time entered "$red_f"0000000000000"$reset_f"\n"$italic"Nothing to count .. returning to Menu.$reset\n";more_options;fi
declare -i  acc=$total_time #Local variable
##find half
declare -i half_time=$(( total_time / 2 )) #will only be read at the start 
while [[ $acc -gt 0 ]] ;do
	# printf "Time remaining in seconds: $total_time\n "
	#New total time
	acc=$(( $acc - 1 )) #Arithmetic expansion
	printf "$red_f"
	printf "\rTime remaining in seconds:--> $white_f%s"$green_f"Select an option to proceed -: ->> "$reset_f"" "[ $acc ]"
	# printf ""$green_f"Select an option to proceed -: -->> \r" $reset_f
	printf "$reset_f"
	sleep 1 #To count one second gone
	#Alert when its half time
	while [[ $acc -eq $half_time ]];do 
		printf ""$magenta_f"Half of the time is gone"$reset"\n";
		printf "Checking for any commands issued to execute . . . \n";
	if [[ -z $command_exec_half_time ]];then
		printf "No command issued\n"
		 # printf "Command found executing $red_f $command_exec_half_time $reset_f\n";
	else 
		printf "Executing command $red_f%s\n$reset" "$command_exec_half_time"
		 $command_exec_half_time 
		# printf "No command issued command found\n"; ##command was found
	fi
	break 
	done #Break after one cycle of this check
	while [[ $acc -eq 0 ]];do 
			printf $red_f"\nTime is up !\n"$reset"";
			printf "Checking if there is command instruction to execute...\n"
			if [[ -z $command_exec ]];then 
				printf "No command issued.. Returning to Program. . .\n"; #more_options ##Back to whichever menu user will be using
			 else
																							
				printf "Executing command $red_f%s\n$reset" "$command_exec";fi
				##Execute that command
				$command_exec
	break
	done 
done& ##Timer Is a Background JOb
printf ""$yellow_f"Timer will run in Background mode..$reset_f" ;
# return 0
# read -t 0.1 -p "" 
# more_options
# while [[ $acc -eq $half_time ]];do printf "Half of the time is gone\n";done
# echo #BAck to shell 
}

write_cmd(){
command_exec="" #Initial is blank
command_exec_half_time="" #initial is blank
#when_exec=""
read -p "Execute command at what time ? [Half time/ Full time [Default is full time. Select 'h' or 'f' or 'q' to bypass this and go to counter]]: -->> " when_exec

if [[ -z $when_exec ]];then read -p  "Type command to be executed at Full time and hit enter: " command_exec;calculate; #answer=no;
elif [[ $when_exec == q  ]];then calculate #Direct to counter section
elif [[  $when_exec == h||   $when_exec == H ||   $when_exec == f ||   $when_exec == F ]];then 
	ans_do=$when_exec; #set this variable to reference answer
	if [[ $ans_do == h ||  $ans_do == H ]];then 
							read -p  "Type command to be executed at [Half Time]  and hit enter: " command_exec_half_time 
							calculate
						elif  [[ $ans_do == f || $ans_do == F ]];
						then
							 read -p  "Type command to be executed at Full time and hit enter: " command_exec;
							 calculate ;
						
						fi
else
							echo -e "$magenta_f"
							 printf "Invalid  answer please repeat or press q to bypass this prompt!\n";
							 write_cmd;
							 echo -e $reset_f


fi

# elif [[ $when_exec != 1	 ||	$when_exec != 2 || $when_exec != q ]];then 
# 	printf "Invalid option ..\n";
# 	write_cmd
# elif [[ $when_exec -eq q ]];then calculate #Bypass this feature
# elif [[ $when_exec -eq 1 || $when_exec -eq 2 ]];then do_exec=$when_exec
# 	if [[ $do_exec -eq 1 ]];then 
# 		read -p  "Type command to be executed at [Half Time]  and hit enter: " command_exec_half_time 
# 		calculate 
# 	elif [[ $do_exec -eq 2 ]];then 
# 		read -p  "Type command to be executed and hit enter: " command_exec
# 		calculate 
# 	fi


# fi
# read -p  "Type command to be executed and hit enter: " command_exec
# calculate #Count time and perfom action
}

action(){
answer=""
read -p "Do wish to run a command when time is up? Y/N or press q to bypass this prompt  [Default is No] " answer
if [[ -z $answer ]];then calculate; #answer=no;
elif [[ $answer == q  ]];then calculate #Direct to counter section
elif [[ $answer == Y||  $answer == y ||  $answer == n ||  $answer == N ]];then 
	answer_do=$answer;if [[ $answer_do == Y || $answer_do == y ]];then 
							write_cmd; #function input command
						elif  [[ $answer_do == N || $answer_do == n ]];
						then echo "Fine .. Proceeding ..";calculate ;fi
else
	 printf "Invalid  answer please repeat or press q to bypass this prompt!\n";action


fi


}


##seconds function
minutes(){
#Initial as blank
local min=""
printf "$cyan_f"
read -p "Enter number of minutes or enter q to quit program [Blank defaults to 0 minutes]: -->> " min #If input is null  then minutes is zero
 printf "$reset_f"
if [[ -z $min ]];then min=0 #Must set this to integer zero if its empty
elif [[ -n $min ]];then	if [[ $min == q ]];then more_options;fi; if [[ ! $min =~ ^[+-]?[0-9]{1,9}+$ ]]; then
		#statements
		printf "Wrong inputs.Minutes can only be an integer number \n"
		minutes #call back function
	fi
fi
count_min=$min #Global var
}


##seconds function
seconds(){
#Initial as blank
local sec=""
printf "$green_f"
read -p "Enter number of seconds or enter q to quit program [Blank defaults to 0 seconds]: -->> " sec #If no input is given seconds will be zero
printf "$reset_f"
if [[ -z $sec ]];then sec=0
elif  [[ -n $sec ]];then  if [[ $sec == q ]];then more_options;fi 
	if [[ ! $sec =~ ^[+-]?[0-9]{1,9}+$ ]]; then
		#statements
		printf "Wrong inputs.Seconds can only be an integer number \n"
		seconds #call back function
	fi
fi
count_sec=$sec #Global var
##convert from here otherwise they will not be available
##convert minutes to seconds
final_minutes=$(( count_min * 60 ))
##final seconds remain same state
final_seconds=$count_sec

##calculate total time added
total_time=$(( $final_minutes + $final_seconds ))

}
#Init
banner_lx
##Call minutes and seconds functions respectively
minutes
seconds
action
##All is set now call this to start timer
# calculate #get to this function based on conditions y/n Y/N

############################################################END OF LINUX COMMAND TIMER Program
# kill_linux_timer=`return 0`
}




more_options(){
echo -en "$green_f"
PS3="Please select an option: >> "
tasks_array=("Network Tasks" "Local System Tasks" "Linux_Command_Timer" "Kill Linux_Command_Timer" "Back to Menu")
select task_main_net in "${tasks_array[@]}";do
	case "${task_main_net[@]}" in 
		 "${tasks_array[0]}")net_tasks;; #call func
		 "${tasks_array[1]}")local_tasks;; #call func
		 "${tasks_array[2]}")linux_timer;; ##call function
		 "${tasks_array[3]}")return linux_timer;; ##call function
		 "${tasks_array[4]}")menu;;
		 *)printf "Invalid option.. Please select from the list\n";
	esac
done
echo -e "$reset_f"

}


############################Matrix 4 fun
matrix_4_fun(){

echo ''#'!/bin/bash' > /matrix_0000.sh
echo 'declare  green_f="\033[32m"' >> /matrix_0000.sh
echo 'declare black_f="\033[30m"' >> /matrix_0000.sh
echo 'declare yellow_f="\033[33m"' >> /matrix_0000.sh
echo 'declare  reset_f="\033[0m"' >> /matrix_0000.sh
echo 'declare magenta_f="\033[35m"' >> /matrix_0000.sh
echo 'declare white_f="\033[37m"' >> /matrix_0000.sh
echo 'declare  dim="\033[2m"' >> /matrix_0000.sh
echo 'declare italic="\033[3m"' >> /matrix_0000.sh
echo 'declare  underline="\033[4m"' >> /matrix_0000.sh
echo 'declare red_f="\033[31m"' >> /matrix_0000.sh
echo 'declare reset="\033[0m"' >> /matrix_0000.sh
echo 'declare -i  int="10" #Integer defined ' >> /matrix_0000.sh
echo 'while (( $int >= 00)) ;do' >> /matrix_0000.sh
echo '	(( int+=2 )) ' >> /matrix_0000.sh
echo ''#'echo -en "$green_f"' >> /matrix_0000.sh
echo '	#echo new value is now "$int"' >> /matrix_0000.sh
echo '	printf "%s\t$magenta_f\t" "$in"' >> /matrix_0000.sh
echo '	printf "%s\t$green_f\t" "$int";' >> /matrix_0000.sh
echo '	printf "%s\t$yellow_f\t" "$int";' >> /matrix_0000.sh
echo '	'#'printf "%s\t$cyan_f\t" "$int";' >> /matrix_0000.sh
echo '	'#'printf "%s\t$red_f\t" "$int";' >> /matrix_0000.sh
echo '	'#'echo -en "$magenta_f"' >> /matrix_0000.sh
echo 'done' >> /matrix_0000.sh

use_terminal=$(ls /usr/bin/ |grep terminal|awk 'NR==1 {print $1}') #use this first terminal you get from output
chmod 774 /matrix_0000.sh
$use_terminal -e  '/matrix_0000.sh' &
printf ""$cyan_f"Done.. Reverting to Terminal ...\n$reset_f"
printf ""$red_f"BEWARE THIS CONSUMES CPU POWER ! ! !\n$reset_f"
##will revert to what function called this


###########End of matrix for fun
}


###################################Author message
author_message(){
echo -e $red_f
cat << "endoftext"
#Author :- Quod Vide
~/
Copyright of QuodVide 2021
All contents present in this software are free to be modified and tweak to the best of wish
@Copyright The_Label ##############Self Tutor
		< M@d3 4 Fun >
		Just chill Out and do what makes you happy ! ! 🏂🏂🏂
		Men on a Mission 👾 👽 The Real Boy 
		######### Fuck The Creator : 3m!l!0 Hu!b3r[t] #########
/~

endoftext
echo -e $reset_f
}

####Start check-root
check_root(){
if [[ $UID -ne 0 ]];then
	printf $red_f"You are not running this tool as root .. Some features will be unavailable..\n"
	read -t 5 -s -r -p $"Press enter key to Continue .." \n null
printf "$reset_f\n"
fi

}
###########End check Root


##Help info
help_info(){
echo -e $cyan_f"
You can start the program without any option and follow the prompts or
use commandline arguments equiped with the program ~/~~~~~~~~~~~~~~~~/
~/##################################################################/~
[Commandline usage] Supply options 

-pr 
--root-pass [~/ Initialize the plugin to change root user password]
-pu
--other-pass [~/ Initialize the plugin to change other users passwords]
-t
--timer [~/ Start the timer utility]
-m4
--matrix-4-fun [~/ Start simple matriz 4 fun]
-k4 
--kill-matrix-4-fun [~/ Kill matrrix for fun]
-r 
--restart-script [~/ Restart the script for whatever reason]
-a 
--about  [~/ About the author]
-pf 
--port-forward [~/ SSH port forwarding options]
-cr
--chat-room [~/ Simple netcat chatroom utility]
-h
--help [~/ This help menu ]
~/##################################################################/~
"
echo -e $reset_f
}
##End help_info


script_install(){
cp -rv "$script_path"/pkgs_00 /usr/bin/
cp -v "$script_path"/$script_name /usr/bin/tweak
echo -e $green_f"Installation SUCCEDED"$reset
}


menu() {
clear

local green_p=$(echo -e $green_f"Select a single option: >> xx $reset_ps3 $reset_f")
# init
banner_main #banner function
echo
# printf "Starting Program .... \n" |pv -qL 35 2>/dev/null #NOt available in all distros
#green_color #Color format untill stop
PS3="$green_p"
# read -t 0.1 -p ""
#reset_color #End of green
select action_m in "Change root user passwd" "Change password of other users" "More options" "Matrix_4_fun" "Kill Matrix_4_fun" "Restart Program" "Quit program" "About Author" "Install the program"
do
	case "$action_m" in
		"Change root user passwd")root_pass;;
		 "Change password of other users")other_user_select;;
		 "More options")more_options;;
		 "Matrix_4_fun")matrix_4_fun;;
		 "Kill Matrix_4_fun" )killall matrix_0000.sh 2>/dev/null;if [[ $? == 0 ]];then printf "Done ...\n";else printf "Matrix_4_fun  is not Running.\n";fi;;
		  "Restart Program")"$script_path"/"$real_name";; #Refer location
		 "Quit program")echo -n "Quiting . . ." |pv -qL 13 2> /dev/null;echo -en $cyan_f"\nbye :)";echo -e " "$white_f" Report bugs to https://github.com/3mili@n0445";printf ""$red_f"+++++++++++++"$yellow_f"++++++JUST++++++"$cyan_f"+++++4+++++"$magenta_f"+++++++++FUN++++++++"$black_f"++++++++++++++++"$white_f"+++++++++++++++\n$reset_f";killall "$real_name" 2>/dev/null &killall "$real_name" 2>/dev/null &killall "$real_name" 2>/dev/null;;
		  "About Author")author_message;; 
		 "Install the program")script_install;;
		 *)printf "Invalid option.. Please select from the list\n";

	esac
done

}



green_ps3=$(echo -e $green_f"Select a single option: >> ^X $reset_ps3 $reset_f")

cyan_f="\033[36m"
#function start
start() {
clear
init
#Get real name

banner_main #banner function
echo
printf "Starting Program .... \n" |pv -qL 35 2>/dev/null #NOt available in all distros
#green_color #Color format untill stop
PS3="$green_ps3"
# read -t 3 -p '' #test
#reset_color #End of green
# read -t 0.1 -p "" 
select action in "Change root user passwd" "Change password of other users" "More options" "Matrix_4_fun" "Kill Matrix_4_fun" "Restart Program" "Quit program" "About Author" "Install the program"
do
	case "$action" in
		 "Change root user passwd")root_pass;;
		 "Change password of other users")other_user_select;;
		 "More options")more_options;;
		 "Matrix_4_fun")matrix_4_fun;;
		 "Kill Matrix_4_fun" )killall matrix_0000.sh 2>/dev/null;if [[ $? == 0 ]];then printf "Done ...\n";else printf "Matrix_4_fun  is not Running.\n";fi;;
		 "Restart Program")"$script_path"/"$real_name";; #Wecall the script name using  a variable name to escape the forward slash and avoid infinity
		 "Quit program")echo -n "Quiting . . ." |pv -qL 13 2> /dev/null;echo -en $cyan_f"\nbye :)";echo -e ""$white_f" Report bugs to https://github.com/3mili@n0445";printf "\n"$red_f"+++++++++++++"$yellow_f"++++++JUST++++++"$cyan_f"+++++4+++++"$magenta_f"+++++++++FUN++++++++"$black_f"++++++++++++++++"$white_f"+++++++++++++++\n$reset_f";killall "$real_name" 2>/dev/null &killall "$real_name" 2>/dev/null &killall "$real_name" 2>/dev/null;;
		 "About Author")author_message;; #call func info
		 "Install the program")script_install;;
		 *)printf "Invalid option.. Please select from the list\n";

	esac  #Ignore 2>&1
done

}

##trash ref
#org_pid=""; org_pid=`pidof "$0"`;pd=""; pd=`pwd`;"$pd"/"$real_name";pd=""; kill -9 $org_pid;break;;
###check root
check_root
##call function start
#start
if [[ ! "${1}" ]];then start;
else
	while true;do
		case "${1}" in
				-pr|--root-pass)root_pass;;
				-pu|--other-pass)other_user_select;;
				-t|--timer)linux_timer;;
				-m4|--matrix-4-fun)matrix_4_fun;;
				-k4|--kill-matrix-4-fun)killall matrix_0000.sh 2>/dev/null;if [[ $? == 0 ]];then printf "Done ...\n";else printf "Matrix_4_fun  is not Running.\n";fi;;
				-r|--restart-script)"$script_path"/"$real_name";;
				-a|--about)author_message;;
				-pf|--port-forward)ssh_forward;;
				-cr|--chat-room)chat_room_option;;
				-h|--help)help_info;;
				-i|--install)script_install;;
				*)printf "Invalid option supplied.. Use < $real_name > -h or '--help' to get usage information\n";
		esac
		break
	done
fi
