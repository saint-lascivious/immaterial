#!/bin/bash

ASSET_LIST="${ASSETS:-immaterial_assets}"
SOURCE_DIR="${SOURCE:-source}"


GET_SOURCE(){
    if [ ! -d "$SOURCE_DIR" ]; then
        printf "source directory unavailable, creating it ...\n"
        mkdir -p "$SOURCE_DIR"
        printf "completed\n\n"
    fi
    pushd "$SOURCE_DIR"
    printf "cleaning source directory ...\n"
    rm *.svg
    printf "completed\n\n"
    printf "downloading source files ...\n\n"
    wget -i "../$ASSET_LIST" -q
    printf "completed\n\n"
    popd
}

GET_SOURCE