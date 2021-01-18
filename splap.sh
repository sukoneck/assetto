#!/bin/sh
set -e

# Use this to splap out an assetto container 
# Pass a preset to it like "splap.sh 07". Add a second argument to clean up containers like "splap.sh 07 clean" 

# Set 'em up specific to ad hoc splapping. All other envs are already set by startup.sh
set_variables() {
  echo ">>> Setting environment variables"
  ASSETTO_PRESET=$1   # Two digit number that matches your (e.g.) ../Assetto/Server/Presets/SERVER_00 folder
  CONTAINER_IMAGE=    # Assetto server container image. You want this one "sukoneck/assetto:latest"
  KEEP_IT_CLEAN=$2    # Should existing containers get cleaned up?
  PORT_HTTP=8081      # Assetto HTTP port. Must match your server_cfg.ini
  PORT_TCPUDP=9600    # Assetto TCP/UPD port. Must match your server_cfg.ini
  MOUNT_PATH_DEST=    # Path that will exist in the containers e.g. /mnt/assetto
  MOUNT_PATH_SOURCE=  # Path that exists on the host e.g. /mnt/c/programfiles/Assetto/Server
  STEAM_PASSWORD=     # Steam host password
  STEAM_USERNAME=     # Steam host username
}

# Clean up containers if that's what you're into 
clean_it_up() {
  if [ -n ${KEEP_IT_CLEAN} ]; then
    echo ">>> Freshening up all containers"
    docker stop $(sudo docker ps -aq)
    docker rm $(sudo docker ps -aq)
  else
    echo ">>> Leaving existing containers alone"
  fi
}

# Pull the latest image from docker hub
pull_container_image() {
  echo ">>> Getting the latest container image for ${CONTAINER_IMAGE}"
  docker pull ${CONTAINER_IMAGE} -q
}

# Go on, get
run_container() {
  echo ">>> Starting Assetto server container"
  docker run -d \
    -v ${MOUNT_PATH_SOURCE}/content:${MOUNT_PATH_DEST}/content \
    -v ${MOUNT_PATH_SOURCE}/Presets/SERVER_${ASSETTO_PRESET}:${MOUNT_PATH_DEST}/cfg \
    -e MOUNT_PATH_DEST=${MOUNT_PATH_DEST} \
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
clean_it_up
pull_container_image
run_container
