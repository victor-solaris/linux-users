#!/bin/bash

# VERIFY ROOT USER
if [[ $(whoami) != 'root' ]]; then
  echo "Run as root" && exit 1;
fi


# VERIFY ARGUMENTS
if [[ $1 == "-h" ]]; then
  echo -e "\nUsage: $0 <username> <group name> <number of accounts>\n"
  exit 1
fi

if [[ $# -ne 3 ]]; then
  echo -e "\nIllegal number of parameters"
  echo -e "\nUsage: $0 <username> <group name> <number of accounts>\n"
  exit 1
fi

username="$1"
group="$2"
max="$3"

re1='^[0-9]'
if [[ $username =~ $re1 ]]; then   
  echo -e "\nERROR: Username cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <group name> <number of accounts>\n"
  exit 1
fi

re1='^[0-9]'
if [[ $group =~ $re1 ]]; then   
  echo -e "\nERROR: Group name cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <group name> <number of accounts>\n"
  exit 1
fi

re2='^[0-9]+$'
if ! [[ $max =~ $re2 ]]; then
  echo -e "\nERROR: \"Number of Accounts\" parameter not a number."
  echo -e "\nUSAGE: $0 <username> <group name> <number of accounts>\n"
  exit 1
fi


# CHECK IF THERE ARE ACCOUNTS TO BE DELETED
totalaccounts="$(grep -c "$username*" "/etc/passwd")"
if [[ $totalaccounts -eq 0 ]];then
  echo -e "\nThere are $totalaccounts  account(s) to be deleted." 
  exit 1
else
  echo -e "\nThere are $totalaccounts account(s) to be deleted."
fi


# DELETE USER ACCOUNTS
for (( i=1; i <= max; i++  ));do 
   echo -e "\n***** ""$username""$i"" ********************************************\n"
   if grep -q "$username""$i" /etc/passwd; then
     
     # delete user crontabs
     crontab -r -u "$username""$i" > /dev/null
     
     # log out users
     killall -u "$username""$i"     
      
     # delete user accounts
     /usr/sbin/userdel -r "$username""$i"
    
     if ! grep -q "$username""$i" "/etc/passwd";then
        echo "User account successfully deleted"
     fi;
   else
     echo "User account does not exist. "
   fi;
done
echo


# DELETE GROUP
echo -e "\n***** Remove Group **************************************\n"
if grep -q -1 "$group" "/etc/group";then
  groupdel $group
  echo -e "Group deleted: $group\n"
else
  echo -e "Group does not exist: $group\n"
fi


# DELETE USER ACCOUNTS/PASSWORD FILE 
rm useraccounts.csv.gpg
