# Automate Conda Installation

OS: CentOS 7

Purpose: 
  (1) Create multiple user accounts
  (2) Install Miniconda3-latest-Linux-x86_64.sh
  (3) Install qiime2-2020.8-py36-linux-conda.yml

Required:
    - gpg
    - Miniconda3-latest-Linux-x86_64.sh
    - qiime2-2020.8-py36-linux-conda.yml

## 1 - create_user.sh
- Create group
- Create user accounts. 
- Assign a random password to each user. 
- Input username, group name, number of accounts, number of days
before expiration, passphrase for encryption. 
- Username/password written to an encypted csv file. 

## 2 - cp_pkg.sh
- Download Miniconda3-latest-Linux-x86_64.sh
- Download qiime2-2020.8-py36-linux-conda.yml

- Copy Miniconda3-latest-Linux-x86_64.sh to user account.
- Copy qiime2-2020.8-py36-linux-conda.yml to user account.  

## 3 - install_conda.sh
- Install Miniconda3 in home directory of each user.

## 4 - update_conda.sh
- Add the conda command to the user environment. 
- Update conda. 
- Add bioconda and conda-forge channels.

## 5 - main.sh
- Call scripts (create_user.sh, cp_pkg.sh, install_conda.sh, update_conda.sh) 

## 6 - install_qiime2.sh
- Install qiime2 as conda environment
- Long installation process; not included in main.sh
