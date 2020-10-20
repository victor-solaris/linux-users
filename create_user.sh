#!/bin/bash

if [[ $(whoami) != 'root' ]]; then 
  echo "Run as root" && exit 1;
fi

date > "$0".log

if [ "$1" == "-h" ]; then
  echo -e "\nUsage: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

if [ $# -ne 5 ]; then
  echo -e "\nERROR: Illegal number of parameters"
  echo -e "\nUSAGE: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

USERNAME="$1"
GROUP="$2"
MAX="$3"
EXPIRE="$4"
MYPASS="$5"

STARTUID=5000

re1='^[0-9]'
if [[ $USERNAME =~ $re1 ]]; then 
  echo -e "\nERROR: Username cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

if [[ $GROUP =~ $re1 ]]; then 
  echo -e "\nERROR: Group name cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

re2='^[0-9]+$'
if ! [[ $MAX =~ $re2 ]]; then
  echo -e "\nERROR: \"Number of Accounts\" parameter not a number."
  echo -e "\nUSAGE: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

if ! [[ $EXPIRE =~ $re2 ]]; then
  echo -e "\nERROR: \"Number of Days Until Expiration\" parameter not a number."
  echo -e "\nUSAGE: $0 <username> <group> <number of accounts> <number of days until expiration> <passphrase>\n"
  exit 1
fi

echo -e "\nUsername: ""$USERNAME" | tee -a "$0".log
echo -e "Groupname: ""$GROUP" | tee -a "$0".log
echo -e "Number of Accounts: ""$MAX" | tee -a "$0".log
echo -e "Expiration date: ""$(date -d "$EXPIRE days" +"%Y-%m-%d")" | tee -a "$0".log

if grep -q "$GROUP" "/etc/group";then
  echo -e "\nGroup $GROUP already exists" >> "$0".log
else
  groupadd $GROUP
fi

for (( i=1; i<=MAX; i++ ));do
 
  x=$(( STARTUID + i)) 
  
  banner="\n***** ""$USERNAME""$i"" ********************************************\n"
  
  if  ! grep -q "$USERNAME""$i" "/etc/passwd"; 
    then
      echo -e "$banner"
      /usr/sbin/useradd -u $x -e "$(date -d "$EXPIRE days" +"%Y-%m-%d")" -g "$GROUP" -m "$USERNAME""$i" 2>&1 | tee -a "$0".log;
      echo -e "User account created.\n" 
      
      password="$(openssl rand -base64 8 | cut -b -10)"
      echo "$USERNAME""$i":"$password" | chpasswd
  
      echo "$USERNAME""$i","$password" >> useraccounts.csv
  
    else
      echo -e "$banner" >> "$0".log
      echo -e "User account: ""$USERNAME""$i"" already exist" >> "$0".log
  fi; 
done

gpg -c --batch --passphrase "$MYPASS" useraccounts.csv
shred -u  useraccounts.csv
echo 

