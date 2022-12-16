#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"
ACE_INVENTORY_SRC="https://raw.githubusercontent.com/tobigremmer-dt/on-the-fly-installer-test/main"

# Prevent input prompts by specifying frontend is not interactive
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

echo "INIT - Update apt-get and upgrade already install packages..."
sudo apt-get update && sudo apt-get dist-upgrade -y

echo "INIT - Setting up Python..."
sudo apt-get install python3-pip -y
python3 -m pip --version
python3 -m pip install --upgrade pip -q

echo "INIT - Installing Ansible..."
python3 -m pip install ansible

/home/$ACE_BOX_USER/.local/bin/ansible-galaxy collection install https://storage.googleapis.com/ace-box-public-roles/ace_box-operator-0.0.0.tar.gz
/home/$ACE_BOX_USER/.local/bin/ansible-playbook ace_box.operator.init

# echo "INIT - Installing ACE CLI..."
# python3 -m pip install https://storage.googleapis.com/ace-box-public-roles/ace_cli-0.0.0-py3-none-any.whl

# # .ace setup
# echo "INIT - Initializing user ACE-Box..."
# mkdir -p /home/$ACE_BOX_USER/.ace/ansible
# curl -sfL $ACE_INVENTORY_SRC/ansible/init.yml -o /home/$ACE_BOX_USER/.ace/ansible/init.yml
# /home/$ACE_BOX_USER/.local/bin/ansible-playbook /home/$ACE_BOX_USER/.ace/ansible/init.yml --extra-vars "ace_box_user=$ACE_BOX_USER" --extra-vars "ace_inventory_src=$ACE_INVENTORY_SRC"

# # ACE prepare
# /home/$ACE_BOX_USER/.local/bin/ace prepare

# if [ ! -z "${ACE_BOX_USE_CASE}" ]; then
#   echo "INIT - Setting up use case..."
#   /home/$ACE_BOX_USER/.local/bin/ace enable $ACE_BOX_USE_CASE
# fi
