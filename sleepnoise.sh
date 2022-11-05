#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
NPREFIX=$SCRIPT_DIR/files
SCHEDULE=$SCRIPT_DIR/schedule.txt
VOLATILE=/tmp
LOG_FILE=~/logs_sleepnoise.log
NOW=$(date "+%Y-%m-%d %H:%M:%S")

#noise="$NPREFIX/audiocheck.net_white_192k_-3dBFS.wav"
#noise="$NPREFIX/audiocheck.net_pink_192k_-3dBFS.wav"
noise="$NPREFIX/audiocheck.net_brownnoise.wav"

# copy wav to tmpfs for 0 disk usage
[[ -f "$VOLATILE/${noise##*/}" ]] || cp "$noise" "$VOLATILE"

volume=$1
echo "$NOW volume" $volume >> $LOG_FILE

while true
do
  repeats=10000
  echo "$NOW ${noise##*/} $repeats" >> $LOG_FILE
  AUDIODEV=hw:2,0 play --volume=$volume -q -c 2 "$VOLATILE/${noise##*/}" repeat $repeats >/dev/null
done
