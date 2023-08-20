#/bin/bash

# Extract Ngrok PID using grep and awk
NGROK_PID_LINE=$(grep -o 'Ngrok PID: [0-9]*' "local_pid.log")
NGROK_PID=$(echo $NGROK_PID_LINE | awk '{print $NF}')

# Display the extracted Ngrok PID
echo "Stopping Ngrok PID: $NGROK_PID"

# Kill local process
kill $NGROK_PID

# User output
echo "Done."