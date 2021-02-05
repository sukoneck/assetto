# Summary

`NOTE: These probably don't work anymore.`

# Splap out a single container 
## Summary
The splap script makes is easy mode for changing the Assetto server based on presets like the kind acServerManager.exe creates.

## Usage
    ../splap.sh 07 clean

# Mobilize the armada
## Summary 
Archive has a container host startup script for deploying infinite servers and seeing the matrix, but who's got the time. 

## Usage
1. On the container host (assumes VM) add the cron job described in startup.sh
2. Populate the variable values in startup.sh and make sure the PORT_PREFIX matches your server_cfg.ini files
3. Restart your container host
4. Overtake your opponent using the gutter technique during the five hairpin turns on the Akina downhill (obviously)