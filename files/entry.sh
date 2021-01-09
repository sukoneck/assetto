#!/bin/sh
set -e

cd /home/steam

install_steamcmd() {
  echo ">>> Installing steamcmd"
    wget 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' 
    tar -xvzf steamcmd_linux.tar.gz 
    rm -f steamcmd_linux.tar.gz 
    chmod -R 755 /home/steam/ 
}

install_assetto() {
  echo ">>> Installing assetto corsa via steamcmd"
  /home/steam/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +login ${STEAM_USERNAME} ${STEAM_PASSWORD} \
    +force_install_dir /home/steam/assetto \
    +app_update 302550 validate \
    +quit
}

config_assetto() {
  echo ">>> Configuring assetto using cfg files"
    cp /home/steam/files/* /home/steam/assetto/cfg/
    rm -rf /home/steam/assetto/content
    ln -s /mnt/content /home/steam/assetto/content
    chmod -R 755 /home/steam/
}

start_assetto() {
  echo ">>> Starting assetto corsa server"
  cd /home/steam/assetto
  /home/steam/assetto/acServer start
}

install_steamcmd
install_assetto
config_assetto
start_assetto