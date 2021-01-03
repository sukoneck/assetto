# tried using ubuntu but this happened https://github.com/ValveSoftware/steam-for-linux/issues/7190
FROM debian:buster-slim

LABEL maintainer="daniel@sukoneck.com"

# these are used by entry.sh to login to steam via steamcmd
ENV STEAM_USERNAME=
ENV STEAM_PASSWORD=

# get dependencies for steamcmd and assetto corsa then clean yourself up
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=8.3.0-6 \
		lib32gcc1=1:8.3.0-6 \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
		nano=3.2-3 \
		libsdl2-2.0-0:i386=2.0.9+dfsg1-1 \
		curl=7.64.0-4+deb10u1 \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# pull in the entrypoint script and assetto corsa cfg files 
COPY files/ /home/steam/files/

# end by kicking off a script because steam and assetto are chonk and "container images should be small"
ENTRYPOINT [ "/home/steam/files/entry.sh" ]