FROM ubuntu:18.04
ARG URL

LABEL org.opencontainers.image.source='https://github.com/acbgbca/minecraft-bedrock-docker', \
      org.opencontainers.image.title='Minecraft Bedrock Server - Docker'

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    libssl1.1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /opt/minecraft \
  && mkdir -p /opt/minecraft/orig_cfg \
  && mkdir -p /config \
  && mkdir -p /worlds

COPY start.sh /opt/minecraft

RUN curl $URL --output /opt/bedrock-server.zip && \
    unzip /opt/bedrock-server.zip -d /opt/minecraft && \
    rm /opt/bedrock-server.zip && \
    mv /opt/minecraft/*.json /opt/minecraft/*.properties /opt/minecraft/orig_cfg/ && \
    rm -df /opt/minecraft/worlds && \
    chmod -R a+rw /opt/minecraft /config /worlds && \
    ln -s /worlds /opt/minecraft/worlds

VOLUME [ "/worlds", "/config" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]