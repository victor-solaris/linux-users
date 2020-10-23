#!/bin/bash

#1 Create training directory
#2 Create workshop directory
#3 Verify tarball exists in workshop directory
#4 Create symlink to tarball in users' ~/$WORKSHOP directory 


# VERIFY USER

if [[ $(whoami) != 'root' ]]; then 
  echo "Run as root" && exit 1;
fi

date > "$0".log

# VERIFY ARGUMENTS

if [ "$1" == "-h" ]; then
  echo -e "\nUSAGE: $0 <username> <workshop>\n"
  exit 1
fi

if [ $# -ne 2 ]; then
  echo -e "\nERROR: Illegal number of parameters"
  echo -e "\nUSAGE: $0 <username> <workshop>\n"
  exit 1
fi

WORKSHOP="$1"
USERNAME="$2"

re1='^[0-9]'
if [[ $USERNAME =~ $re1 ]]; then 
  echo -e "\nERROR: Username cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <workshop>\n"
  exit 1
fi

if [[ $WORKSHOP =~ $re1 ]]; then 
  echo -e "\nERROR: Workshop name cannot start with a number."
  echo -e "\nUSAGE: $0 <username> <workshop>\n"
  exit 1
fi

echo -e "\nUsername: ""$USERNAME" | tee -a "$0".log
echo -e "Workshop: ""$WORKSHOP" | tee -a "$0".log


# CREATE TRAINING DIRECTORY IF REQUIRED
TRAINING_DIR="/ibread/chicago-remote/training/"


# CREATE WORKSHOP DIRECTORY IF REQUIRED

if ! find "$TRAINING_DIR" -type d -name "$WORKSHOP" > /dev/null; then
  mkdir -p "$TRAINING_DIR""$WORKSHOP"
  chmod 774 "$TRAINING_DIR""$WORKSHOP"
  chmod g+s "$TRAINING_DIR""$WORKSHOP"
  echo -e "\nDirectory $WORKSHOP created."
  find "$TRAINING_DIR" -type d -name "$WORKSHOP"
else
  echo "Directory: $TRAINING_DIR""$WORKSHOP"
fi | tee -a "$0".log

if ! find "$TRAINING_DIR" -type d -name "$WORKSHOP" > /dev/null ; then
  echo "Directory "$WORKSHOP" not found."
  exit 1
fi | tee -a "$0".log

# CHECK IF TARFILE EXISTS
TARGET=$(find "$TRAINING_DIR""$WORKSHOP" -name "$WORKSHOP".tar.gz)

if [[ -z "$TARGET" ]]; then
  echo "Symlink target not found: ""$WORKSHOP".tar.gz
  exit 1
else
  echo "Target: $TARGET"
fi | tee -a "$0".log

# FIND NUMBER OF USERS
echo -e "\nNumber user accounts [ $USERNAME ]: "$(grep -cE ^"$USERNAME" /etc/passwd)"\n" | tee -a "$0".log

# CREATE SYMLINK TO USERS
for user in $(grep -E ^"$USERNAME" /etc/passwd | cut -d : -f1); do
 home_dir=$(runuser -l $user -c 'echo $HOME')
 dest_dir="$home_dir/$WORKSHOP"
 echo "Copying symlink from target to: ""$user"" in ""$dest_dir"
 mkdir -p "$dest_dir"
 ln -s "$TARGET" "$dest_dir/$WORKSHOP.tar.gz"  
done | tee -a "$0".log








