#!/bin/bash

if [ "$EULA" != TRUE ]; then
  echo
  echo "EULA must be set to TRUE to indicate agreement with the Minecraft End User License. See https://minecraft.net/terms"
  echo
  exit 1
fi

echo "Started as $EUID"

# If we are running as root, setup user
if [ $EUID == 0 ]; then
  umask 0002
  USER=minecraft
  UID=${UID:-1000}
  GID=${GID:-1000}

  echo "Setting user $USER to $UID:$GID"

  groupmod -o -g "$GID" $USER
  usermod -o -u "$UID" $USER
fi

# If the config directory is empty, initialise with the contents from orig_cfg
if [ -z "$(ls /config)" ]; then
    echo "Initialising config"
    cp -v /opt/minecraft/orig_cfg/* /config
    chown -RP $USER.$USER /config
fi

# Create symbolic links from the files in /config to the minecraft directory
ln -sf /config/* /opt/minecraft

if [ $EUID == 0 ]; then
  echo "Running as $USER"
  su -c "export LD_LIBRARY_PATH=. && umask 0002 && exec ./bedrock_server" $USER
else
  export LD_LIBRARY_PATH=.
  umask 0002
  exec ./bedrock_server
fi