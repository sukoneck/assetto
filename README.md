# Summary
## [Docker Hub](https://hub.docker.com/r/sukoneck/assetto)
Dockerfile and entry script for an Assetto Corsa server running in a Debian container. Docker Hub builds `sukoneck/assetto:latest` on commit to Github `sukoneck/assetto@main`.

## [Github](https://github.com/sukoneck/assetto)
The splap script makes is easy mode for changing the Assetto server based on presets like the kind acServerManager.exe creates. Archive has a container host startup script for deploying infinite servers and seeing the matrix, but who's got the time. 

# Usage
## Run a single container ad hoc

    docker run -d \
        -v <mount_path_source>/content:<mount_path_dest>/content \  # where the "content" folder lives on the host
        -v <mount_path_source>/cfg:<mount_path_dest>/cfg \          # where the "cfg" folder lives on the host
        -e MOUNT_PATH_DEST=<mount_path_dest> \                      # the same as <mount_path_dest>
        -e STEAM_USERNAME=<username> \                              # your steam username
        -e STEAM_PASSWORD=<password> \                              # your steam password
        -p 9600:9600/tcp \                                          # TCPUDP port used by Assetto
        -p 9600:9600/udp \                                          # TCPUDP port used by Assetto
        -p 8081:8081/tcp \                                          # HTTP port used by Assetto
        -p 8081:8081/udp \                                          # HTTP port used by Assetto
        sukoneck/assetto:latest                                     # Container image in dockerhub

## Splap out a single container 

    ../splap.sh 07 clean

## Mobilize the armada (archived)

1. On the container host (assumes VM) add the cron task described in startup.sh
2. Populate the variable values in startup.sh and make sure the PORT_PREFIX matches your server_cfg.ini files
3. Restart your container host
4. Overtake your opponent using the gutter technique during the five hairpin turns on the Akina downhill (obviously)

# References

This repo was heavily influenced by these awesome projects:
 - https://github.com/CM2Walki/steamcmd
 - https://github.com/germanrcuriel/assetto-corsa-server
