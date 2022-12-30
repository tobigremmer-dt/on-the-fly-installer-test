#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"

ACE_BOX_OPERATOR_SRC_DEFAULT="https://storage.googleapis.com/ace-box-public-roles/ace_box-operator-0.0.0.tar.gz"
ACE_BOX_OPERATOR_SRC="${ACE_BOX_OPERATOR_SRC:-$ACE_BOX_OPERATOR_SRC_DEFAULT}"

# Prevent input prompts by specifying frontend is not interactive
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

echo "INIT - Update apt-get and upgrade already install packages..."
sudo apt-get update && sudo apt-get dist-upgrade -y

echo "INIT - Setting up Python..."
sudo apt-get install python3-pip -y
python3 -m pip --version
python3 -m pip install --upgrade pip -q

#
# ace_box.operator.init permanently updates PATH in .bashrc.
# Additionally, an updated PATH is temporarily exported for 
# the remainder of the install script or for situations where
# .bashrc is not sourced.
#
export PATH=/home/$ACE_BOX_USER/.local/bin:$PATH

echo "INIT - Installing Ansible..."
python3 -m pip install ansible

ansible-galaxy collection install $ACE_BOX_OPERATOR_SRC
ansible-playbook ace_box.operator.init -i localhost,

ace prepare

if [ ! -z "${ACE_BOX_USE_CASE}" ]; then
  echo "INIT - Setting up use case..."
  ace enable $ACE_BOX_USE_CASE
fi
