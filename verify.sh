#!/bin/bash

# Start server in the background
./start.sh&

ps

# Wait up to 60 seconds for the server to start
SECONDS=0
until ss -tulnp | grep 19132
do
  
  if (( SECONDS > 60 ))
  then
     echo "Giving up..."
     exit 1
  fi

  ss -tulnp
  ps
  echo "Bedrock server is not up yet. Waiting..."
  sleep 5
done