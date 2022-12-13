#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"

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

# .ace setup
echo "INIT - Initializing user ACE-Box..."
mkdir -p /home/$ACE_BOX_USER/.ace/playbooks
sudo curl -sfL https://raw.githubusercontent.com/tobigremmer-dt/on-the-fly-installer-test/main/playbooks/init.yml -o /home/$ACE_BOX_USER/.ace/playbooks/init.yml
/home/$ACE_BOX_USER/.local/bin/ansible-playbook /home/$ACE_BOX_USER/.ace/playbooks/init.yml --extra-vars "ace_box_user=$ACE_BOX_USER"

ace prepare

if [ ! -z "${ACE_BOX_USE_CASE}" ]; then
  echo "INIT - Setting up use case..."
  ace enable $ACE_BOX_USE_CASE
fi
