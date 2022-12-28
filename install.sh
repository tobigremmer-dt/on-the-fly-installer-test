#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"
ACE_BOX_OPERATOR_SRC="https://storage.googleapis.com/ace-box-public-roles/ace_box-operator-0.0.0.tar.gz"

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

/home/$ACE_BOX_USER/.local/bin/ansible-galaxy collection install $ACE_BOX_OPERATOR_SRC
/home/$ACE_BOX_USER/.local/bin/ansible-playbook ace_box.operator.init

# TBD: Reload shell?
exec /bin/sh

# ACE prepare
/home/$ACE_BOX_USER/.local/bin/ace prepare

if [ ! -z "${ACE_BOX_USE_CASE}" ]; then
  echo "INIT - Setting up use case..."
  /home/$ACE_BOX_USER/.local/bin/ace enable $ACE_BOX_USE_CASE
fi
