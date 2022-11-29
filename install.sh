#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"

# Install required libs incl. ace-cli
sudo curl -sfL https://raw.githubusercontent.com/tobigremmer-dt/on-the-fly-installer-test/main/cli/ace -o /usr/local/bin/ace
sudo chmod 0755 /usr/local/bin/ace

# ace prepare
ace

# Conditionally, ace enable $USE_CASE
