# Summary
Dockerfile and config files for an Assetto Corsa server running on an Ubuntu container.

# Use
To build:

    docker build . -t sukoneck/assetto:latest

To run:

    docker run -e STEAM_USERNAME=<name> -e STEAM_PASSWORD=<pass> -p 9600:9600/tcp -p 9600:9600/udp -p 8081:8081/tcp -p 8081:8081/udp -it sukoneck/assetto
