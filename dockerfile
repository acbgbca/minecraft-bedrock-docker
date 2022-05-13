FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libssl1.1 \
  && rm -rf /var/lib/apt/lists/*

ADD bedrock-server.zip /opt

RUN mkdir /opt/minecraft && \
    unzip /opt/bedrock-server.zip -d /opt/minecraft && \
    rm /opt/bedrock-server.zip

COPY start.sh /opt/minecraft

VOLUME [ "/opt/minecraft/worlds" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]