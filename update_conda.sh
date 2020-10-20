#!/bin/bash

if [[ $(whoami) != 'root' ]]; then
  echo "Run as root" && exit 1;
fi

USERNAME="$1"

for username in $(cut -f 1 -d : /etc/passwd | grep -e "^$USERNAME*");do
  
  echo -e "\n***** ""$username"" ********************************************\n"
   
  echo "Updating Conda ..."
          
  runuser -l "$username" -c 'echo "source ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc'
  echo "Added conda command to environment."
      
  runuser -l "$username" -c 'echo "y" | conda update conda' > /dev/null 2>&1 &
  echo "Conda updated succesfully!"
       
  runuser -l "$username" -c 'conda config --add channels bioconda'
  runuser -l "$username" -c 'conda config --add channels conda-forge'
done



