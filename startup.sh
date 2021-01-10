#!/bin/sh
set -e

# This host startup script is nice to add as a cron task
# Use "sudo crontab -e" and then add the line "@reboot <path>/startup.sh"

# Set 'em up
set_variables() {
  echo ">>> Setting environment variables"
  AZURE_FILE_NAME=    # Azure files container name
  AZURE_FILE_USED=    # "true" or "false" are you mounting Azure file storage to your host? 
  CONTAINER_IMAGE=    # Assetto server container image
  MOUNT_PATH_DEST=    # Path that will exist in the containers
  MOUNT_PATH_SOURCE=  # Path that exists on the host. If using Azure files: /<directory>/${AZURE_FILE_NAME}
  PORT_PREFIX_HTTP=   # Assetto HTTP port when combined with server count  
  PORT_PREFIX_TCPUD=  # Assetto TCP/UPD port when combined with server count
  STEAM_PASSWORD=     # Steam host password
  STEAM_USERNAME=     # Steam host username
}

# Chill out, bro
chill_out() {
  echo ">>> Letting the host wake up a little" && sleep 10 &
  PID=$!
  wait $PID
}

# Check path and creds exist before attempting to mount Azure files storage
validate_storage_prerequisites() {
  echo ">>> Validating storage pre-requisites are met"
  # Make sure the mount destination on the host exists
  if [ ! -d "${MOUNT_PATH_SOURCE}" ]; then
    echo ">>> ERROR: destination directory on host for mounting Azure file storage is missing. Fixing it, but that's wack."
    mkdir ${MOUNT_PATH_SOURCE}
  fi
  # Make sure the credential file for Azure file storage exists
  if [ ! -f "/etc/smbcredentials/${AZURE_FILE_NAME}.cred" ]; then
    echo ">>> ERROR: credential file on host for mounting Azure file storage is missing. Exiting."
    exit 1
  fi
}

# Mount Azure file storage to the host
mount_storage() {
  echo ">>> Mounting Azure file storage container: ${AZURE_FILE_NAME}"
  mount -t cifs //${AZURE_FILE_NAME}.file.core.windows.net/${AZURE_FILE_NAME} ${MOUNT_PATH_SOURCE} -o vers=3.0,credentials=/etc/smbcredentials/${AZURE_FILE_NAME}.cred,dir_mode=0777,file_mode=0777,serverino
}

# Pull the latest image from docker hub
pull_container_image() {
  echo ">>> Getting the latest container image for ${CONTAINER_IMAGE}"
  docker pull ${CONTAINER_IMAGE}
}

# Deploy a container for each server definition
run_containers() {
  echo ">>> Starting all Assetto server containers"
  # Get the count of directories in the ../content folder (aka presets)
  SERVER_COUNT=$(expr $(ls ${MOUNT_PATH_SOURCE}/content | wc -l) - 1)
  # Prepend "0" for formatting if single digit
  if [ $SERVER_COUNT -le 9 ]; then 
    SERVER_COUNT=0${SERVER_COUNT}; 
  fi
  # Go on, get
  for SERVER in $(seq -w 00 $SERVER_COUNT); do
    PORT_HTTP=${PORT_PREFIX_HTTP}${SERVER}
    PORT_TCPUDP=${PORT_PREFIX_TCPUDP}${SERVER}
    docker run -d \
      -v ${MOUNT_PATH_SOURCE}/content:${MOUNT_PATH_DEST}/content \
      -v ${MOUNT_PATH_SOURCE}/cfg:${MOUNT_PATH_DEST}/cfg \
      -e ASSETTO_CFG=${SERVER} \
      -e MOUNT_PATH_DEST=${MOUNT_PATH_DEST}
      -e STEAM_USERNAME=${STEAM_USERNAME} \
      -e STEAM_PASSWORD=${STEAM_PASSWORD} \
      -p ${PORT_TCPUDP}:${PORT_TCPUDP}/tcp \
      -p ${PORT_TCPUDP}:${PORT_TCPUDP}/udp \
      -p ${PORT_HTTP}:${PORT_HTTP}/tcp \
      -p ${PORT_HTTP}:${PORT_HTTP}/udp \
      ${CONTAINER_IMAGE}
  done
}

# Send it
set_variables
chill_out
if [ ${AZURE_FILE_USED} = true ]; then
  validate_storage_prerequisites
  mount_storage
fi
pull_container_image
run_containers