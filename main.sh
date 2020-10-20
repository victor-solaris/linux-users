#!/bin/bash

if [[ $(whoami) != 'root' ]]; then 
  echo "Run as root" && exit 1;
fi

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

./create_user.sh $USERNAME $GROUP $MAX $EXPIRE $MYPASS
./cp_pkg.sh $USERNAME
./install_conda.sh $USERNAME
./update_conda.sh $USERNAME


