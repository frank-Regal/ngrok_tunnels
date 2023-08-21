#!/bin/bash

# Get the directory of the current bash script
CUR_DIR=$(dirname "$0")

# Extract Ngrok PID using grep and awk
NGROK_PID_LINE=$(grep -o 'Ngrok PID: [0-9]*' "$CUR_DIR/local_pid.log")
NGROK_PID=$(echo $NGROK_PID_LINE | awk '{print $NF}')

# Display the extracted Ngrok PID
echo "Stopping NGROK restful api PID: $NGROK_PID"

# Kill local process
kill $NGROK_PID

rm $CUR_DIR/local_pid.log

# User output
echo "Done."