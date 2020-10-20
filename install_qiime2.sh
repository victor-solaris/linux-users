#!/bin/bash

if [[ $(whoami) != 'root' ]]; then
  echo "Run as root" && exit 1;
fi

for username in $(cut -f 1 -d : /etc/passwd | grep -e "^train*"); do
  runuser -l "$username" -c 'echo "y" | conda env create -n qiime2-2020.8 --file qiime2-2020.8-py36-linux-conda.yml'

done
