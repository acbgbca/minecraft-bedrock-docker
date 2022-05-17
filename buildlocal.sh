#!/bin/bash

export URL=`curl -H "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock|grep -o "https://minecraft.azureedge.net/bin-linux/bedrock-server-.*.zip"`
export VERSION=`echo $URL|grep -o "[0-9.]*[0-9]"`

if [ -z "$(ls bedrock-server.zip)" ]; then
    curl $URL --output ./bedrock-server.zip
fi

echo "URL: $URL"
echo "VERSION: $VERSION"

docker build -f Dockerfile-local -t minecraft-bedrock:alpha . --build-arg URL=$URL --build-arg VERSION=$VERSION
