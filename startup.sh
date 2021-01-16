#!/bin/sh
set -e

# This host startup script is nice to add as a cron task
# Use "sudo crontab -e" and then add the line "@reboot <path>/startup.sh"

# Set 'em up
set_variables() {
  echo ">>> Setting environment variables"
  ASSETTO_PRESET=     # Which preset you finna pop? Should be a two digit number
  AZURE_FILE_NAME=    # Azure files container name
  AZURE_FILE_USED=    # "true" or "false" are you mounting Azure file storage to your host? 
  CONTAINER_IMAGE=    # Assetto server container image. You want this one "sukoneck/assetto:latest"
  MOUNT_PATH_DEST=    # Path that will exist in the containers
  MOUNT_PATH_SOURCE=  # Path that exists on the host. If using Azure files: /<directory>/${AZURE_FILE_NAME}
  OS_USERNAME=        # The OS user to assign docker permissions 
  PORT_HTTP=          # Assetto HTTP port. Must match your server_cfg.ini
  PORT_TCPUDP=        # Assetto TCP/UPD port. Must match your server_cfg.ini
  STEAM_PASSWORD=     # Steam host password
  STEAM_USERNAME=     # Steam host username
}

# Chill out, bro
chill_out() {
  echo ">>> Letting the host wake up a little" && sleep 69 &
  PID=$!
  wait $PID
}

# Install docker if it's not already there
validate_docker() {
  if [ -x "$(command -v docker)" ]; then
    echo ">>> Installing docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker ${OS_USERNAME}
  else
    echo ">>> Docker is ready to roll"
  fi
}

# Keep it fresh
apt-gets() {
  echo ">>> Checking for updates to git, cifs-utils, and docker"
    apt-get upgrade -y git
    apt-get upgrade -y cifs-utils
    apt-get update 
    apt-get upgrade -y
}

# Check path and creds exist before attempting to mount Azure files storage. You still need to run the initial config script from Azure first
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

# Go on, get
run_container() {
  echo ">>> Starting Assetto server container"
  docker run -d \
    -v ${MOUNT_PATH_SOURCE}/content:${MOUNT_PATH_DEST}/content \
    -v ${MOUNT_PATH_SOURCE}/cfg:${MOUNT_PATH_DEST}/cfg \
    -e ASSETTO_CFG=${ASSETTO_PRESET} \
    -e MOUNT_PATH_DEST=${MOUNT_PATH_DEST}
    -e STEAM_USERNAME=${STEAM_USERNAME} \
    -e STEAM_PASSWORD=${STEAM_PASSWORD} \
    -p ${PORT_TCPUDP}:${PORT_TCPUDP}/tcp \
    -p ${PORT_TCPUDP}:${PORT_TCPUDP}/udp \
    -p ${PORT_HTTP}:${PORT_HTTP}/tcp \
    -p ${PORT_HTTP}:${PORT_HTTP}/udp \
    ${CONTAINER_IMAGE}
}

# Send it
set_variables
chill_out
validate_docker
if [ ${AZURE_FILE_USED} = true ]; then
  validate_storage_prerequisites
  mount_storage
fi
pull_container_image
run_container