FROM ubuntu:16.04
MAINTAINER Sigurd Boe <sig.boe@gmail.com>

# create user for steam
RUN adduser \
	--home /home/steam \
	--disabled-password \
	--shell /bin/bash \
	--gecos "user for running steam" \
	--quiet \
	steam

# install dependencies
RUN apt-get update && \
    apt-get install -y curl lib32gcc1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Downloading SteamCMD and make the Steam directory owned by the steam user
RUN mkdir -p /opt/steamcmd &&\
    cd /opt/steamcmd &&\
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -vxz &&\
    chown -R steam /opt/steamcmd


# SteamCMD should not be used as root, here we set up user and variables
USER steam
WORKDIR /opt/steamcmd

# Execution vector
ENTRYPOINT ["/opt/steamcmd/steamcmd.sh"]
