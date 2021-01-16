#!/bin/sh
set -e

# Use this to splap out an assetto container 
# Pass a preset to it like "splap.sh 07". Add a second argument to clean up containers like "splap.sh 07 clean" 

# Set 'em up specific to ad hoc splapping. All other envs are already set by startup.sh
set_variables() {
  echo ">>> Setting environment variables"
  ASSETTO_PRESET=$1   # Which preset you finna pop? Should be a two digit number
  KEEP_IT_CLEAN=$2    # 
  PORT_HTTP=86${1}    # Assetto HTTP port. Must match your server_cfg.ini
  PORT_TCPUDP=96${1}  # Assetto TCP/UPD port. Must match your server_cfg.ini
}

# Clean up containers if that's what you're into 
clean_it_up() {
  if [ -n ${KEEP_IT_CLEAN} ]; then
    echo ">>> Freshening up containers"
    docker stop $(sudo docker ps -aq)
    docker rm $(sudo docker ps -aq)
  else
    echo ">>> Leaving existing containers alone"
  fi
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
clean_it_up
pull_container_image
run_container