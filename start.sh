#!/bin/bash

# If the config directory is empty, initialise with the contents from orig_cfg
if [ -z "$(ls -A /config)" ]; then
    echo "Initialising config"
    cp -v /opt/minecraft/orig_cfg/* /config
fi

# Create symbolic links from the files in /config to the minecraft directory
ln -sf /config/* /opt/minecraft

export LD_LIBRARY_PATH=.

exec ./bedrock_server