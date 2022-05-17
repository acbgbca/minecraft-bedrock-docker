FROM ubuntu:18.04
ARG URL
ARG VERSION
ARG GROUPNAME=mcg
ARG GROUP_GID=999
ARG USERNAME=minecraft
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    libssl1.1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && umask 0002 \
  && mkdir -p /opt/minecraft \
  && mkdir -p /opt/minecraft/orig_cfg \
  && mkdir -p /config \
  && mkdir -p /worlds \
  && groupadd --gid $GROUP_GID $GROUPNAME \
  && chgrp -R $GROUPNAME /opt/minecraft \
  && chmod 775 /opt/minecraft /opt/minecraft/orig_cfg /config /worlds \
  && groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && usermod -a -G $GROUPNAME $USERNAME

COPY start.sh /opt/minecraft

RUN curl $URL --output /opt/bedrock-server.zip \
  && umask 0002 \
  && unzip /opt/bedrock-server.zip -d /opt/minecraft \
  && rm /opt/bedrock-server.zip \
  && chown -R $USERNAME.$GROUPNAME /opt/minecraft /config /worlds \
  && mv /opt/minecraft/*.json /opt/minecraft/*.properties /opt/minecraft/orig_cfg/ \
  && rm -df /opt/minecraft/worlds \
  && ln -s /worlds /opt/minecraft/worlds

LABEL org.opencontainers.image.source='https://github.com/acbgbca/minecraft-bedrock-docker' \
      org.opencontainers.image.documentation='https://github.com/acbgbca/minecraft-bedrock-docker' \
      org.opencontainers.image.title='Minecraft Bedrock Server - Docker' \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.base.name=docker.io/ubuntu:18.04

ENV UID=1000
ENV GID=1000
ENV EULA=false

VOLUME [ "/worlds", "/config" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]