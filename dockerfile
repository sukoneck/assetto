FROM ubuntu:latest

LABEL maintainer="daniel@sukoneck.com"

ARG STEAM_USERNAME
ARG STEAM_PASSWORD
ARG ASSETTO_SERVER_CFG
ARG ASSETTO_ENTRY_LIST

RUN set -x \
    # get dependencies
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
		lib32gcc1 \
        lib32stdc++6 \
		wget \
        zlib1g:i386 \ 
    # set up directory and permissions for /home/steam/assetto/
    && mkdir /home/steam \
    && chmod -R 755 /home/steam/ \
    && cd /home/steam \
    # get and prep steamcmd
    && wget http://media.steampowered.com/client/steamcmd_linux.tar.gz \
    && tar -xvf steamcmd_linux.tar.gz \
    && rm -f steamcmd_linux.tar.gz \
    # configure networking
    && ufw allow 9600 \
    && ufw allow 8081 \
    && ufw enable \
    # configure steam and download assetto server
    && ./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +@sSteamCmdForcePlatformType windows +force_install_dir ./assetto +app_update 302550 validate +quit \
    # configure assetto server
    && cd /home/steam/assetto/cfg \
    && wget ...server_cfg.ini \
    && wget ...entry_list.ini \
    && cd /home/steam \
    # configure stracker? depends on zlib1g:i386
    # ???
    # start the server
    && ./acServer start





