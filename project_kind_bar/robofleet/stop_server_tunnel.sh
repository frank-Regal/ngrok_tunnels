#/bin/bash

# Extract Ngrok PID using grep and awk
NGROK_PID_LINE=$(grep -o 'Ngrok PID: [0-9]*' "local_pid.log")
echo $NGROK_PID_LINE

NGROK_PID=$(echo $NGROK_PID_LINE | awk '{print $NF}')

# Display the extracted Ngrok PID
echo "Stopping Ngrok PID: $NGROK_PID"

kill $NGROK_PID

echo "Done."