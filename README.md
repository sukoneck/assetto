# Summary

Dockerfile and entry script for an Assetto Corsa server running in a Debian container. Docker Hub builds `sukoneck/assetto:latest` on commit to Github `sukoneck/assetto@main`. 

# Links
 - Docker Hub: https://hub.docker.com/r/sukoneck/assetto 
 - Github: https://github.com/sukoneck/assetto

# Usage
## Docker compose

Update the following values in the docker-compose.yml file then use `docker-compose up -d`

    <password>   # your steam username (use a throwaway)
    <path>       # directory on host where presets and content folders live, (e.g.) ../Assetto/Server
    <preset>     # two digit number that matches your (e.g.) ../Assetto/Server/Presets/SERVER_00 folder that acServerManager.exe creates
    <username>   # your steam password (use a throwaway)

## Run ad hoc container

    docker run -d \
        -e ASSETTO_PRESET=<preset> \               # which preset to use (see above)
        -e STEAM_PASSWORD=<password> \             # your steam password (use a throwaway)
        -e STEAM_USERNAME=<username> \             # your steam username (use a throwaway)
        -p 8081:8081/tcp \                         # HTTP port used by Assetto in server_cfg.ini
        -p 8081:8081/udp \                         # HTTP port used by Assetto in server_cfg.ini
        -p 9600:9600/tcp \                         # TCPUDP port used by Assetto in server_cfg.ini
        -p 9600:9600/udp \                         # TCPUDP port used by Assetto in server_cfg.ini
        -v <path>/content:/mnt/assetto/content \   # where the "content" folder lives on the host
        -v <path>/presets:/mnt/assetto/presets \   # where the "presets" folder lives on the host
        sukoneck/assetto:latest                    # container image in dockerhub

# References

This repo was heavily influenced by these awesome projects:
 - https://github.com/CM2Walki/steamcmd
 - https://github.com/germanrcuriel/assetto-corsa-server
