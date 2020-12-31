# # configure steam and download assetto server
# && cd /home/steam \
# && ./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD \
#     +@sSteamCmdForcePlatformType windows \
#     +force_install_dir ./assetto \
#     +app_update 302550 validate \
#     +quit 
# # configure assetto server
# && cd /home/steam/assetto/cfg \
# && rm -f ./* \
# && wget $ASSETTO_SERVER_CFG \
# && wget $ASSETTO_ENTRY_LIST \
# && chmod -R 755 /home/steam/ \
# # attach custom tracks/cars
# # && link content to place \
# # configure stracker? depends on zlib1g:i386
# # ???
# # leave in the right directory
# && cd /home/steam/assetto/