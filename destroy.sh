#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"

#
# PATH is temporarily exported in cases 
# .bashrc is not sourced.
#
export PATH=/home/$ACE_BOX_USER/.local/bin:$PATH

ace destroy
