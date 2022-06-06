#!/bin/bash

target=${1:-app}

export URL=`curl -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock|grep -o "https://minecraft.azureedge.net/bin-linux/bedrock-server-.*.zip"`
export VERSION=`echo $URL|grep -o "[0-9.]*[0-9]"`
export VERSION_MAJOR=`echo $VERSION|grep -o "[0-9]*\.[0-9]*"|head -1`

if [ -z "$(ls bedrock-server.zip)" ]; then
    curl $URL --output ./bedrock-server.zip
fi

echo "URL: $URL"
echo "VERSION: $VERSION"
echo "MAJOR VERSION: $VERSION_MAJOR"
echo "Build Target: $target"
export DOCKER_BUILDKIT=1
docker build --target $target -t minecraft-bedrock:alpha . --build-arg URL=./bedrock-server.zip --build-arg VERSION=$VERSION
