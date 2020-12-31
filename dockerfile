FROM debian:buster-slim

LABEL maintainer="daniel@sukoneck.com"

ARG STEAM_USERNAME
ARG STEAM_PASSWORD
ARG ASSETTO_SERVER_CFG
ARG ASSETTO_ENTRY_LIST

# COPY . /app

RUN set -x \
    # get dependencies
    && dpkg --add-architecture i386 \
    && apt-get update 
RUN set -x \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=8.3.0-6 \
		lib32gcc1=1:8.3.0-6 \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
		nano=3.2-3 \
		libsdl2-2.0-0:i386=2.0.9+dfsg1-1 \
		curl=7.64.0-4+deb10u1 \
        && apt-get clean autoclean \
        && apt-get autoremove -y 
WORKDIR /home/steam
RUN set -x \
    # get and prep steamcmd
    && wget 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm -f steamcmd_linux.tar.gz \
    && chmod -R 755 /home/steam/ 
RUN set -x \
    # configure steam and download assetto server
    && /home/steam/steamcmd.sh +@sSteamCmdForcePlatformType windows \
        +login $STEAM_USERNAME $STEAM_PASSWORD \
        +force_install_dir ./assetto \
        +app_update 302550 validate \
        +quit 
WORKDIR /home/steam/assetto/cfg
RUN set -x \
    # configure assetto server
    # && cd /home/steam/assetto/cfg \
    && rm -f /home/steam/assetto/cfg/* \
    && wget $ASSETTO_SERVER_CFG \
    && wget $ASSETTO_ENTRY_LIST \
    && chmod -R 755 /home/steam/ 
    # attach custom tracks/cars
    # && link content to place \
    # configure stracker? depends on zlib1g:i386
    # ???
    # leave in the right directory
    # && cd /home/steam/assetto/
WORKDIR /home/steam/assetto
CMD ["/home/steam/assetto/acServer","start"]



# VOLUME $STEAMAPPDIR

# # Set Entrypoint
# # 1. Update server
# # 2. Replace config parameters with ENV variables
# # 3. Start the server
# # You may not like it, but this is what peak Entrypoint looks like.
# ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
# 			+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
# 		&& /bin/sed -i -e 's/{{SERVER_PW}}/'"$SERVER_PW"'/g' \
# 			-e 's/{{SERVER_ADMINPW}}/'"$SERVER_ADMINPW"'/g' \
# 			-e 's/{{SERVER_MAXPLAYERS}}/'"$SERVER_MAXPLAYERS"'/g' ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
# 		&& /bin/sed -i -e 's/{{SERVER_TICKRATE}}/'"$SERVER_TICKRATE"'/g' \
# 			-e 's/{{SERVER_DEFAULTMAP}}/'"$SERVER_DEFAULTMAP"'/g' ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini \
# 		&& ${STEAMAPPDIR}/MordhauServer.sh -log \
# 			-Port=$SERVER_PORT -QueryPort=$SERVER_QUERYPORT -BeaconPort=$SERVER_BEACONPORT \
# 			-GAMEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
# 			-ENGINEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini

# # Expose ports
# EXPOSE 27015/udp 15000/tcp 7777/udp


# EXPOSE 20100 \
# 	8700 \
# 	27000