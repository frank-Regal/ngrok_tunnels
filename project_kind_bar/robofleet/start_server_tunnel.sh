#!/bin/bash

# Get the directory of the current bash script
CUR_DIR=$(dirname "$0")

# Set NGROK variables specific to robofleet server websocket connection
PORT="8080" # robofleet websocket server is default to 8080
TYPE="tcp"
OUTPUT_FILE="$CUR_DIR/server_tunnel.log"

# Path to configuration file (change variables in here)
CONFIG_FILE="$CUR_DIR/../config/kind_bar_config.ini"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

# Source the config file to load variables
source "$CONFIG_FILE"

# Start ngrok tunnel and save process id
echo "Starting NGROK tunnel for robofleet server ..."
ngrok $TYPE $PORT --authtoken $NGROK_RF_AUTH_TOKEN --log=stdout > $OUTPUT_FILE &
NGROK_PID=$!

# sleep for 5 secs for ngrok to start
sleep 5
echo "Ngrok PID: $NGROK_PID" > "$CUR_DIR/local_pid.log"

# Use grep to extract the line containing the URL pattern in the output file
URL_LINE=$(grep -Eo 'url=tcp://[^[:space:]]+' $OUTPUT_FILE)

# Use sed to extract the URL value
NGROK_URL=$(echo "$URL_LINE" | sed -E 's/url=tcp:\/\/([^:]+:[0-9]+)/\1/')

# Construct JSON data for POST or PATCH
JSON_DATA='{"uid": "'"$NGROK_RF_PROCESS_UID"'", 
            "ngrokurl": "'"$NGROK_URL"'",
            "username": "'"$NGROK_RF_USERNAME"'",
            "port": "'"$PORT"'",
            "type": "'"$TYPE"'"}'

# Define the PostgREST database endpoint URLs
#POSTGREST_URL="https://blessed-star-buzzard.ngrok-free.app/regaldbtable"
POSTGREST_URL="https://$NGROK_PSQL_HTTP_STATIC_DOMAIN/$PSQL_TABLE"

# Check if the UID exists by sending a GET request
RESPONSE=$(curl -s -X GET "$POSTGREST_URL?uid=eq.$NGROK_RF_PROCESS_UID")

if [ "$RESPONSE" = "[]" ]; then
  # UID doesn't exist, perform POST
  curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$POSTGREST_URL"
  echo "NGROK URL ($NGROK_URL) POSTed to database."
else
  # UID exists, perform PATCH
  curl -X PATCH -H "Content-Type: application/json" -d "$JSON_DATA" "$POSTGREST_URL?uid=eq.$NGROK_RF_PROCESS_UID"
  echo "NGROK URL ($NGROK_URL) PATCHed to database."
fi

echo "Robofleet server tunnel started."