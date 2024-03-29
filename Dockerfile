# syntax=docker/dockerfile:1.4

ARG USERNAME=minecraft
ARG USER_UID=1000
ARG USER_GID=1000
ARG DIST=ubuntu

FROM ubuntu:22.04 as download
ARG URL
ARG GROUPNAME
ARG GROUP_GID
ARG USERNAME
ARG USER_UID
ARG USER_GID
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends unzip

ADD $URL ./

RUN unzip /app/*.zip -d /app/minecraft \
  && rm /app/*.zip

FROM ubuntu:22.04 as base-ubuntu
ARG GROUPNAME
ARG GROUP_GID
ARG USERNAME
ARG USER_UID
ARG USER_GID

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libcurl4 \
    iproute2

RUN umask 0002 \
  && mkdir -p /opt/minecraft \
  && mkdir -p /opt/minecraft/orig_cfg \
  && mkdir -p /config \
  && mkdir -p /worlds \
  && groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && chown $USERNAME.$USERNAME /opt/minecraft /config /worlds /opt/minecraft/orig_cfg \
  && chmod 777 /opt/minecraft /opt/minecraft/orig_cfg /config /worlds

FROM base-$DIST as app
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

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD ss -ul | grep 19132

VOLUME [ "/worlds", "/config" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]