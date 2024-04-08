# linuxsteamcmd modupdated
 
Simple linux script created for Linux Game Servers running with SteamCMD to facilitate maintaining mods uup to date.
This is my first real linux script that I've written working my way up to more complexe stuff.
This was designed around a [Squad](https://www.joinsquad.com) Server running un [LGSM](https://linuxgsm.com).

## Setup:
Add in you correct paths on the lines 4 & 5:
- SRVPATH -> Path to your game server
- MODPATH -> path to the folder where the Mods need to be moved

## Commands:
```shell
# Install a new mod
./updateMods -install <mod_id>
# update all mods already downloaded
./updateMods -update
# List all currently downloaded mods
./updateMods -list
# Delete All currently installed mods
./updateMods -removeall
# Delete a specific mod
./updateMods -remove <mod_id>
```
