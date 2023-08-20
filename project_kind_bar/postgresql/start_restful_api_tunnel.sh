#!/bin/bash
  
# Set NGROK variables specific to robofleet server websocket connection
PORT="3000"
TYPE="http"
OUTPUT_FILE="restful_api_tunnel.log"

# Path to configuration file (change variables in here)
CONFIG_FILE="./../config/kind_bar_config.ini"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

# Source the config file to load variables
source "$CONFIG_FILE"

echo "Starting PostgresSQL RESTFul API Tunnel ..."

# Start ngrok tunnel and save process id
ngrok $TYPE --domain=blessed-star-buzzard.ngrok-free.app $PORT --authtoken $NGROK_PSQL_AUTH_TOKEN --log=stdout > $OUTPUT_FILE &
NGROK_PID=$!

# Write PID to file to kill later on.
echo "Ngrok PID: $NGROK_PID" > "local_pid.log"

# User output.
echo "Done."

