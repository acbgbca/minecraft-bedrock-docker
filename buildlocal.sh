#!/bin/bash

set -e

target=${1:-app}

export USER_AGENT="user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36"
export URL=`curl https://net-secondary.web.minecraft-services.net/api/v1.0/download/links|jq -r '.result.links[] | select(.downloadType=="serverBedrockLinux") | .downloadUrl'`
export VERSION=`echo $URL|grep -o "[0-9.]*[0-9]"`
export VERSION_MAJOR=`echo $VERSION|grep -o "[0-9]*\.[0-9]*"|head -1`

echo "URL: $URL"
echo "VERSION: $VERSION"
echo "MAJOR VERSION: $VERSION_MAJOR"
echo "Build Target: $target"

MATCHING=$(docker pull acbca/minecraft-bedrock:$VERSION)
if [ -z "$MATCHING" ]; then
    echo "No existing version"
else
    echo "We have an existing version"
fi

echo "URL: $URL"
echo "VERSION: $VERSION"
echo "MAJOR VERSION: $VERSION_MAJOR"
echo "Build Target: $target"
export DOCKER_BUILDKIT=1
docker build --target $target -t minecraft-bedrock:alpha . --build-arg URL=$URL --build-arg VERSION=$VERSION
