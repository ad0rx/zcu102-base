#!/bin/bash
#
# Build the BOOT.BIN file

if [ -z ${PROJWS} ]
then
    echo "Please source the project setup file"
    exit
fi

# Source petalinux to get the build toolchain
source "${PETALINUX_SETTINGS}"

bootgen -arch zynqmp -image "${BOOT_DIR}/boot.bif" -o "${BOOT_DIR}/boot.bin"
