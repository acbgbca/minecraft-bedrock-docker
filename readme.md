[![Build](https://github.com/acbgbca/minecraft-bedrock-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/acbgbca/minecraft-bedrock-docker/actions/workflows/docker-image.yml) [![1](https://ghcr-badge.egpl.dev/acbgbca/minecraft-bedrock/latest_tag?trim=major)](https://github.com/acbgbca/minecraft-bedrock-docker/pkgs/container/minecraft-bedrock) [![1](https://ghcr-badge.egpl.dev/acbgbca/minecraft-bedrock/size)](https://github.com/acbgbca/minecraft-bedrock-docker/pkgs/container/minecraft-bedrock)

# Minecraft Bedrock Server - Docker Container

A Docker implementation of the [Minecraft Bedrock Server](https://www.minecraft.net/en-us/download/server/bedrock). The container is built by a CI pipeline that checks daily for new versions. Container is available via both [Docker Hub](https://hub.docker.com/r/acbca/minecraft-bedrock) and [GitHub Container Registry](https://github.com/acbgbca/minecraft-bedrock-docker/pkgs/container/minecraft-bedrock).

# To Run

## Docker Run

Quick Start
```
docker run -d -e EULA=TRUE -p 19132:19132/udp ghcr.io/acbgbca/minecraft-bedrock
```

With mounted volumes:
```
docker run -d -e EULA=TRUE -p 19132:19132/udp -v minecraft_config:/config -v minecraft_worlds:/worlds ghcr.io/acbgbca/minecraft-bedrock
```

## Docker Compose

```
version: "3.7"
services:
  minecraft:
    image: ghcr.io/acbgbca/minecraft-bedrock:latest
    container_name: minecraft
    environment:
      - EULA=TRUE
    volumes:
      - ./config:/config
      - ./worlds:/worlds
    restart: 'unless-stopped'
    ports:
      - 19132:19132/udp
```

# Environment Variables

- ```EULA```: must be set to ```TRUE``` to indicate acceptance of the [Minecraft End User License Agreement](https://minecraft.net/terms)
- ```UID```: the ID of the user to run the service as. Defaults to 1000
- ```GID```: The ID of the group to run the servie as. Defaults to 1000 

# Exposed Ports

- 19132: Default Minecraft port, can be changed in server.properties. Must be mapped as ```/udp``` or else the client can't connect

# Volumes

- ```/config```: Where the Minecraft config files are stored. Directory will be initialised on first run
- ```/worlds```: Where the world data is stored

# Labels

- ```latest```: always points to the latest version
- ```1.20```: The latest 1.20 release
- ```alpha```: used for testing changes to the container

Each container is also tagged with the exact version of the Bedrock Server it contains.
