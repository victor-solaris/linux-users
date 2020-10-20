#!/bin/bash

if [[ $(whoami) != 'root' ]]; then
  echo "Run as root" && exit 1;
fi

date > "$0".log

USERNAME="$1"

re1='^[0-9]'
if [[ $USERNAME =~ $re1 ]]; then
  echo -e "\nERROR: Username cannot start with a number."
  echo -e "\nUSAGE: $0 <username>\n"
  exit 1
fi

# Download Miniconda3
if [[ -f ~/Downloads/Miniconda3-latest-Linux-x86_64.sh ]]; then
  echo -e "\nMiniconda3-latest-Linux-x86_64.sh already downloaded." >> "$0".log
else
  wget -P ~/Downloads/ https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

# Download Qiime2
if [[ -f ~/Downloads/qiime2-2020.8-py36-linux-conda.yml ]]; then
  echo -e "\nqiime2-2020.8-py36-linux-conda.yml already downloaded." >> "$0".log
else
  wget -P ~/Downloads/ https://data.qiime2.org/distro/core/qiime2-2020.8-py36-linux-conda.yml
fi


for username in $(cut -f 1 -d : /etc/passwd | grep -e "^$USERNAME*"); do
  banner="\n***** ""$username"" ********************************************\n"
  if [[ -f /home/"$username"/Miniconda3-latest-Linux-x86_64.sh ]];
  then
     echo -e "$banner" >> "$0".log
     echo -e "Miniconda3-latest-Linux-x86_64.sh already exists for this user account." >> "$0".log
  else
    echo -e "$banner"
    cp ~/Downloads/Mini* /home/"$username"/
    echo -e "Miniconda3-latest-Linux-x86_64.sh copied to user."
  fi
  
  if [[ -f /home/"$username"/qiime2-2020.8-py36-linux-conda.yml ]];
  then
     echo -e "$banner" >> "$0".log
     echo -e "qiime2-2020.8-py36-linux-conda.yml already exists for this user account." >> "$0".log
  else
    echo -e "$banner"
    cp ~/Downloads/qiime* /home/"$username"/
    echo -e "qiime2-2020.8-py36-linux-conda.yml copied to user."
  fi

done


