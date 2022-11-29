#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"

echo "Hello there, $ACE_BOX_USER!"

# Install required libs incl. ace-cli

# ace prepare

# Conditionally, ace enable $USE_CASE
