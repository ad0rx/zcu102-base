#!/bin/bash
#
# This is a build script to build u-boot from sources on a Linux VM
# The script is invoked from within the VM, and automatically patches
# the u-boot source. This is used because I can't easily build u-boot
# on a Win host, and the VM can't build on a shared folder.
#
#

# The tag to use for checking out from github
UBOOT_TAG="xilinx-v2019.1"

# Path to use for performing the build
# Must be to a VM drive, not shared folder
UBOOT_BUILD_DIR="/mnt/petalinux_builds/u-boot-${UBOOT_TAG}"

echo; echo "Running..."; echo








echo; echo "Done"; echo
