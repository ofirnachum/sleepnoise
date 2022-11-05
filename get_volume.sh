#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCHEDULE=$SCRIPT_DIR/schedule.txt

currenttime=$(date +%H:%M)
currenttimestamp=$(date +%s)
while IFS="" read -r p || [ -n "$p" ]
do
  IFS=" " read -r entry volume endtime <<< "$p"
  if [[ "$entry" == "override" ]] && [[ "$currenttimestamp" < "$endtime" ]]
  then
    break
  elif [[ "$entry" == "set" ]] && [[ "$currenttime" < "$endtime" ]]
  then
    break
  else
    continue
  fi
done < $SCHEDULE

echo "$volume"
