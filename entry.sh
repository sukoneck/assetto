#!/bin/sh
set -e

# This entry script gets Steam and Assetto installed, configured, and running

set_variables() {
  echo ">>> Setting environment variables"
  MOUNT_PATH=${MOUNT_PATH_DEST}
  STEAM_APP_ID=302550
  STEAM_PATH=/home/steam
  STEAMCMD_DOWNLOAD=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
}

install_steamcmd() {
  echo ">>> Installing steamcmd"
  cd ${STEAM_PATH}
  wget ${STEAMCMD_DOWNLOAD}
  tar -xvzf steamcmd_linux.tar.gz 
  rm -f steamcmd_linux.tar.gz 
  chmod -R 755 ${STEAM_PATH}/ 
}

install_assetto() {
  echo ">>> Installing assetto corsa via steamcmd"
  ${STEAM_PATH}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +login ${STEAM_USERNAME} ${STEAM_PASSWORD} \
    +force_install_dir ${STEAM_PATH}/assetto \
    +app_update ${STEAM_APP_ID} validate \
    +quit
}

config_assetto() {
  echo ">>> Configuring assetto using cfg files"
  cp ${MOUNT_PATH}/cfg/SERVER_${ASSETTO_CFG}/* ${STEAM_PATH}/assetto/cfg/
  rm -rf ${STEAM_PATH}/assetto/content
  ln -s ${MOUNT_PATH}/content ${STEAM_PATH}/assetto/content
  chmod -R 755 ${STEAM_PATH}/
}

start_assetto() {
  echo ">>> Starting assetto corsa server"
  cd ${STEAM_PATH}/assetto
  ${STEAM_PATH}/assetto/acServer start
}

install_steamcmd
install_assetto
config_assetto
start_assetto