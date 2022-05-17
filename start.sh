#!/bin/bash

if [ "$EULA" != TRUE ]; then
  echo
  echo "EULA must be set to TRUE to indicate agreement with the Minecraft End User License. See https://minecraft.net/terms"
  echo
  exit 1
fi

# Setup user
USER=minecraft
UID=${UID:-1000}
GID=${GID:-1000}

groupmod -o -g "$GID" $USER
usermod -o -u "$UID" $USER

# If the config directory is empty, initialise with the contents from orig_cfg
if [ -z "$(ls /config)" ]; then
    echo "Initialising config"
    cp -v /opt/minecraft/orig_cfg/* /config
    chown -RP $USER.$USER /config
fi

# Create symbolic links from the files in /config to the minecraft directory
ln -sf /config/* /opt/minecraft

su -c "export LD_LIBRARY_PATH=. && exec ./bedrock_server" $USER