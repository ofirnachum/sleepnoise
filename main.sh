#!/bin/bash

# Automatically run at startup by editting crontab:
# `crontab -e`
# And adding line at end of file:
# `@reboot bash -l /home/ofirnachum/sleepnoise/main`

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VOLUME_SCRIPT=$SCRIPT_DIR/get_volume.sh
NOISE_SCRIPT=$SCRIPT_DIR/sleepnoise.sh

sigint_handler()
{
  rkill $PID
  exit
}

trap sigint_handler SIGINT

while true
do
  volume=$($VOLUME_SCRIPT)
  bash $NOISE_SCRIPT $volume &
  PID=$!

  # Wait until volume changes to restart noise.
  while true
  do
    new_volume=$($VOLUME_SCRIPT)
    if [[ $volume != $new_volume ]]
    then
      break
    fi
    sleep 1
  done

  rkill $PID
done
