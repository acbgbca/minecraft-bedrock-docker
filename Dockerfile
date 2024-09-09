# syntax=docker/dockerfile:1.9

ARG USERNAME=minecraft
ARG USER_UID=1000
ARG USER_GID=1000
ARG DIST=ubuntu
ARG DEBIAN_FRONTEND=noninteractive

FROM ubuntu:22.04@sha256:adbb90115a21969d2fe6fa7f9af4253e16d45f8d4c1e930182610c4731962658 AS download
ARG URL
ARG GROUPNAME
ARG GROUP_GID
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DEBIAN_FRONTEND
WORKDIR /app

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends unzip

ADD $URL ./

RUN unzip -q /app/*.zip -d /app/minecraft \
  && rm /app/*.zip

FROM ubuntu:22.04@sha256:adbb90115a21969d2fe6fa7f9af4253e16d45f8d4c1e930182610c4731962658 AS base-ubuntu
ARG GROUPNAME
ARG GROUP_GID
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DEBIAN_FRONTEND

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    libssl3 \
    libcurl4 \
    iproute2

RUN umask 0002 \
  && mkdir -p /opt/minecraft \
  && mkdir -p /opt/minecraft/orig_cfg \
  && mkdir -p /config \
  && mkdir -p /worlds \
# From ubuntu 23 there is already a 1000 user created with the name 'ubuntu'
  && if id -u $USER_UID; then usermod -l $USERNAME ubuntu; groupmod -n $USERNAME ubuntu; else groupadd --gid $USER_GID $USERNAME; useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
  && chown $USERNAME.$USERNAME /opt/minecraft /config /worlds /opt/minecraft/orig_cfg \
  && chmod 777 /opt/minecraft /opt/minecraft/orig_cfg /config /worlds

FROM base-$DIST AS app
ARG VERSION
ARG USER_UID
ARG USER_GID

COPY start.sh verify.sh /opt/minecraft/

COPY --from=download --chown=$USERNAME:$USERNAME --chmod=777 /app/minecraft /opt/minecraft

RUN umask 0002 \
  && mv /opt/minecraft/*.json /opt/minecraft/*.properties /opt/minecraft/orig_cfg/ \
  && rm -df /opt/minecraft/worlds \
  && ln -s /worlds /opt/minecraft/worlds

LABEL org.opencontainers.image.source='https://github.com/acbgbca/minecraft-bedrock-docker' \
      org.opencontainers.image.documentation='https://github.com/acbgbca/minecraft-bedrock-docker' \
      org.opencontainers.image.title='Minecraft Bedrock Server - Docker' \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.base.name=docker.io/ubuntu:18.04

ENV UID=$USER_UID
ENV GID=$USER_GID
ENV EULA=false
ENV VERSION=$VERSION

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD ss -ul | grep 19132

VOLUME [ "/worlds", "/config" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]