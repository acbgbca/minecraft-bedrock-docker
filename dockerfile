FROM ubuntu:18.04
ARG URL

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libssl1.1 \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/minecraft && \
    curl $URL --output /opt/bedrock-server.zip && \
    unzip /opt/bedrock-server.zip -d /opt/minecraft && \
    rm /opt/bedrock-server.zip

COPY start.sh /opt/minecraft

VOLUME [ "/opt/minecraft/worlds" ]
EXPOSE 19132

WORKDIR /opt/minecraft
CMD [ "./start.sh" ]