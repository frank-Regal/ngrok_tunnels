#!/bin/bash

# start the database api first.
./postgresql/start_restful_api_tunnel.sh
sleep 5

# start the various other tunnels next.
./robofleet/start_server_tunnel.sh
sleep 5

echo "Done."