#!/bin/bash

if [[ $(whoami) != 'root' ]]; then
  echo "Run as root" && exit 1;
fi

USERNAME="$1"


for username in $(cut -f 1 -d : /etc/passwd | grep -e "^$USERNAME*"); do
  banner="\n***** ""$username"" ********************************************\n"
  if [[ -d /home/"$username"/miniconda3 ]];
  then  
    echo -e "$banner" >> "$0".log
    echo -e "Miniconda3-latest-Linux-x86_64.sh is already installed." >> "$0".log
  else
    echo -e "$banner"
    runuser -l "$username" -c 'bash ~/Miniconda3-latest-Linux-x86_64.sh -b'

fi
done




