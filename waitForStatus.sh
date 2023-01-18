#!/bin/sh
# set -e

ACE_BOX_USER="${ACE_BOX_USER:-$USER}"
DEFAULT_TIMEOUT=300
DESIRED_STATUS=$1
CUSTOM_TIMEOUT=$2
TIMEOUT="${CUSTOM_TIMEOUT:-$DEFAULT_TIMEOUT}"
CURRENT_TIME=$(date +%s)
TIMEOUT_AT=$(($CURRENT_TIME + $TIMEOUT))
INTERVAL=10
CURRENT_INTERVAL=$INTERVAL

#
# ace_box.operator.init permanently updates PATH in .bashrc.
# Additionally, an updated PATH is temporarily exported for 
# the remainder of the install script or for situations where
# .bashrc is not sourced.
#
export PATH=/home/$ACE_BOX_USER/.local/bin:$PATH

getSmallerInterval(){
  interval_A=$1
  interval_B=$2

  if [ $interval_A -lt $interval_B ]; then
    CURRENT_INTERVAL=$interval_A
  else
    CURRENT_INTERVAL=$interval_B
  fi
}

getStatus () {
  {
    CURRENT_STATUS=$(ace get status 2>/dev/null)
  } || {
    echo "ACE CLI not yet available..."
  }
}

echo "Waiting $TIMEOUT seconds for status: $DESIRED_STATUS"

while true; do
  getStatus

  CURRENT_TIME=$(date +%s)
  TIMEOUT_IN=$(($TIMEOUT_AT - $CURRENT_TIME))

  if [ "$CURRENT_STATUS" = "$DESIRED_STATUS" ]; then
    break
  elif [ $TIMEOUT_IN -lt 1 ]; then
    echo "Waiting for status $DESIRED_STATUS timed out!"
    exit 1
  elif [ ! -z "$CURRENT_STATUS" ]; then
    echo "Current status: $CURRENT_STATUS. Timeout in $TIMEOUT_IN seconds."
  fi

  getSmallerInterval $INTERVAL $TIMEOUT_IN
  sleep $CURRENT_INTERVAL
done

echo "Successfully received status: $CURRENT_STATUS"
