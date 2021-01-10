# Summary
Dockerfile and entry script for an Assetto Corsa server running in a Debian container. Container host startup script for deploying infinite servers and seeing the matrix.

# Usage
## Run a single container

    docker run -d \
        -v <mount_path_source>/content:<mount_path_dest>/content \  # where the "content" folder lives on the host
        -v <mount_path_source>/cfg:<mount_path_dest>/cfg \          # where the "cfg" folder lives on the host
        -e ASSETTO_CFG=<preset> \                                   # acServerManager.exe stores many server configs
        -e MOUNT_PATH_DEST=<preset> \                               # the same as <mount_path_dest>
        -e STEAM_USERNAME=<username> \                              # your steam username
        -e STEAM_PASSWORD=<password> \                              # your steam password
        -p 9600:9600/tcp \                                          # TCPUDP port used by Assetto
        -p 9600:9600/udp \                                          # TCPUDP port used by Assetto
        -p 8081:8081/tcp \                                          # HTTP port used by Assetto
        -p 8081:8081/udp \                                          # HTTP port used by Assetto
        sukoneck/assetto:latest                                     # Container image in dockerhub

## Mobilize the armada

1. On the container host (assumes VM) add the cron task described in startup.sh
2. Populate the variable values in startup.sh  
3. Restart your container host
4. Overtake your opponent using the gutter technique during the five hairpin turns on the Akina downhill (obviously)

# References

This repo was heavily influenced by these awesome projects:
 - https://github.com/CM2Walki/steamcmd
 - https://github.com/germanrcuriel/assetto-corsa-server