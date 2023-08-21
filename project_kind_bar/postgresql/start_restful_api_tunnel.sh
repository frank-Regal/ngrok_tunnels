#!/bin/bash

# Get the directory of the current bash script
CUR_DIR=$(dirname "$0")  

# Set NGROK variables specific to robofleet server websocket connection
PORT="3000"
TYPE="http"
OUTPUT_FILE="$CUR_DIR/restful_api_tunnel.log"

# Path to configuration file (change variables in here)
CONFIG_FILE="$CUR_DIR/../config/kind_bar_config.ini"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE. Be sure to make a copy of the .sample file and fill in your information"
  exit 1
fi

# Source the config file to load variables
source "$CONFIG_FILE"

echo "Starting NGROK tunnel for postgresql restful api ..."

# Start ngrok tunnel and save process id
ngrok $TYPE --domain=$NGROK_PSQL_HTTP_STATIC_DOMAIN $PORT --authtoken $NGROK_PSQL_AUTH_TOKEN --log=stdout > $OUTPUT_FILE &
NGROK_PID=$!

# Write PID to file to kill later on.
echo "Ngrok PID: $NGROK_PID" > "$CUR_DIR/local_pid.log"

# User output.
echo "PSQL database tunnel started."