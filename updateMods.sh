#!/bin/bash

# Global variables
SRVPATH="/home/squadservers/LigueFrancaiseSquad"
MODPATH="/home/squadservers/LigueFrancaiseSquad/serverfiles/SquadGame/Plugins/Mods"

# Function to update a mod
update_mod() {
    MODID="$1"
    
    # Step 1: Download mod via steamcmd
    steamcmd +force_install_dir "$SRVPATH" +login anonymous +workshop_download_item 393380 "$MODID" +quit
    
    # Step 2: Check if mod folder exists in MODPATH and delete if exists
    if [ -d "$MODPATH/$MODID" ]; then
        echo -e "[\e[33mDeleting\e[0m] mod folder: $MODPATH/$MODID"
        rm -rf "$MODPATH/$MODID"
    fi
    
    # Step 3: Copy mod to MODPATH
    cp -r "$SRVPATH/steamapps/workshop/content/393380/$MODID/" "$MODPATH"
}

# Function to update all mods
update_all_mods() {
    echo -e "[\e[32mUPDATING\e[0m] Started Task to update all current mods"
    for mod_folder in "$MODPATH"/*; do
        if [ -d "$mod_folder" ]; then
            mod_id=$(basename "$mod_folder")
            if [[ "$mod_id" =~ ^[0-9]+$ ]]; then
                echo -e "[\e[32mUpdating\e[0m] mod: $mod_id"
                update_mod "$mod_id"
            else
                echo -e "\e[36mSkipping non-numeric mod folder\e[0m: $mod_id"
            fi
        fi
    done
}

# Function to update a mod
install_mod() {
    MODID="$1"
    
    # Step 1: Download mod via steamcmd
    steamcmd +force_install_dir "$SRVPATH" +login anonymous +workshop_download_item 393380 "$MODID" +quit
    
    # Step 3: Copy mod to MODPATH
    cp -r "$SRVPATH/steamapps/workshop/content/393380/$MODID/" "$MODPATH"
    echo -e "[\e[32mINSTALL\e[0m] Installed Mod: $MODID"
}

# Function to list all current mods
list_mods() {
    echo -e "\e[36mCurrent mods:\e[0m"
    for mod_folder in "$MODPATH"/*; do
        if [ -d "$mod_folder" ]; then
            mod_id=$(basename "$mod_folder")
            if [[ "$mod_id" =~ ^[0-9]+$ ]]; then
                echo -e " - \e[32m$mod_id\e[0m"
                # Get the first folder name inside each mod folder
                first_folder=$(find "$mod_folder" -mindepth 1 -maxdepth 1 -type d -print -quit)
                if [ -n "$first_folder" ]; then
                    echo -e "   - First folder inside: \e[32m$(basename "$first_folder")\e[0m"
                fi
            fi
        fi
    done
}

# Function to remove all mods
remove_all_mods() {
    echo -e "\e[33mRemoving all mods...\e[0m"
    for mod_folder in "$MODPATH"/*; do
        if [ -d "$mod_folder" ]; then
            mod_id=$(basename "$mod_folder")
            if [[ "$mod_id" =~ ^[0-9]+$ ]]; then
                echo -e " - \e[33mDeleting\e[0m mod folder: $mod_id"
                rm -rf "$mod_folder"
            fi
        fi
    done
}

# Function to remove a specific mod
remove_mod() {
    MODID="$1"
    if [ -d "$MODPATH/$MODID" ]; then
        echo -e "[\e[33mRemoving\e[0m] mod: $MODID"
        rm -rf "$MODPATH/$MODID"
    else
        echo -e "[\e[31;1mError\e[0m] Mod $MODID does not exist."
    fi
}

# Main script
if [ "$1" == "-update" ]; then
    update_all_mods
elif [ "$1" == "-install" ]; then
    if [ -z "$2" ]; then
        echo -e "[\e[31;1mError\e[0m] Missing mod ID."
        exit 1
    fi
    install_mod "$2"
elif [ "$1" == "-list" ]; then
    list_mods
elif [ "$1" == "-removeall" ]; then
    remove_all_mods
elif [ "$1" == "-remove" ]; then
    if [ -z "$2" ]; then
        echo -e "[\e[31;1mError\e[0m] Missing mod ID."
        exit 1
    fi
    remove_mod "$2"
else
    echo -e "[\e[33mMISSING ARGUMENT\e[0m] Usage: $0 {-update|-install <mod_id>|-list|-removeall|-remove <mod_id>}"
    exit 1
fi
