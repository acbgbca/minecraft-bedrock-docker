FROM ubuntu:22.04

ADD bedrock-server-.*.zip /opt

RUN mkdir /opt/minecraft && \
    unzip /opt/bedrock-server-.*.zip -d /opt/minecraft && \
    rm /opt/bedrock-server-.*.zip


VOLUME [ "/opt/minecraft/worlds" ]
EXPOSE 19132
EXPOSE 19133
EXPOSE 62426
EXPOSE 62427

WORKDIR /opt/minecraft
CMD [ "LD_LIBRARY_PATH=.", "./bedrock_server" ]