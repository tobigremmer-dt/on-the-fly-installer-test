#!/bin/sh
set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"
DESIRED_STATUS=$1
TIMEOUT="${300:-$2}"
CURRENT_TIME=$(date +%s)
TIMEOUT_AT=$(($CURRENT_TIME + $TIMEOUT))

#
# ace_box.operator.init permanently updates PATH in .bashrc.
# Additionally, an updated PATH is temporarily exported for 
# the remainder of the install script or for situations where
# .bashrc is not sourced.
#
export PATH=/home/$ACE_BOX_USER/.local/bin:$PATH

getStatus () {
  {
    CURRENT_STATUS=$(ace get status)
    echo "Current status: $CURRENT_STATUS"
    return 0
  } || {
    echo "ACE CLI not yet available..."
    return 0
  }
}

echo "Waiting for status: $DESIRED_STATUS"
getStatus

while [ "$CURRENT_STATUS" != "$DESIRED_STATUS" ]; do
  sleep 5
  
  CURRENT_TIME=$(date +%s)
  getStatus

  if [ $TIMEOUT_AT -lt $CURRENT_TIME ]; then
    echo "Waiting for status $DESIRED_STATUS timed out!"
    exit 1
  fi
done

echo "Successfully retrieved desired status: $CURRENT_STATUS"
