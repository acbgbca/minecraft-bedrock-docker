#!/bin/bash

# Start server in the background
./start.sh&

# Wait up to 60 seconds for the server to start
SECONDS=0
until ss -ul | grep 19132
do
  
  if (( SECONDS > 60 ))
  then
     echo "Giving up..."
     exit 1
  fi

  echo "Bedrock server is not up yet. Waiting..."
  sleep 5
done