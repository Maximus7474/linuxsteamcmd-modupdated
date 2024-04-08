#!/bin/bash

# Global variables
SRVPATH="/home/user/"
MODPATH="/home/user/serverfiles/Game/Plugins/Mods"

# Function to update a mod
update_mod() {
    MODID="$1"
    
    # Step 1: Download mod via steamcmd
    steamcmd +force_install_dir "$SRVPATH" +login anonymous +workshop_download_item 393380 "$MODID" +quit
    
    # Step 2: Check if mod folder exists in MODPATH and delete if exists
    if [ -d "$MODPATH/$MODID" ]; then
        rm -rf "$MODPATH/$MODID"
    fi
    
    # Step 3: Copy mod to MODPATH
    cp -r "$SRVPATH/steamapps/workshop/content/393380/$MODID/" "$MODPATH"
}

# Function to update all mods
update_all_mods() {
    for mod_folder in "$MODPATH"/*; do
        if [ -d "$mod_folder" ]; then
            mod_id=$(basename "$mod_folder")
            if [[ "$mod_id" =~ ^[0-9]+$ ]]; then
                update_mod "$mod_id"
            fi
        fi
    done
}

# Function to remove all mods
remove_all_mods() {
    for mod_folder in "$MODPATH"/*; do
        if [ -d "$mod_folder" ]; then
            mod_id=$(basename "$mod_folder")
            if [[ "$mod_id" =~ ^[0-9]+$ ]]; then
                rm -rf "$mod_folder"
            fi
        fi
    done
}

# Function to remove a specific mod
remove_mod() {
    MODID="$1"
    if [ -d "$MODPATH/$MODID" ]; then
        rm -rf "$MODPATH/$MODID"
    fi
}

# Main script
if [ "$1" == "-update" ]; then
    update_all_mods
elif [ "$1" == "-install" ]; then
    if [ -z "$2" ]; then
        exit 1
    fi
    install_mod "$2"
elif [ "$1" == "-list" ]; then
    list_mods
elif [ "$1" == "-removeall" ]; then
    remove_all_mods
elif [ "$1" == "-remove" ]; then
    if [ -z "$2" ]; then
        exit 1
    fi
    remove_mod "$2"
else
    exit 1
fi
