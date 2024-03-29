#!/bin/bash
#
# This is a build script to build u-boot from sources on a Linux VM
# The script is invoked from within the VM, and automatically patches
# the u-boot source. This is used because I can't easily build u-boot
# on a Win host, and the VM can't build on a shared folder.
#
#

if [ -z ${PROJWS} ]
then
    echo "Please source the project setup file"
    exit
fi

# The tag to use for checking out from github
UBOOT_BRANCH="xilinx-v2019.1"
UBOOT_REPO="https://github.com/Xilinx/u-boot-xlnx.git"

# Path to use for performing the build
# Must be to a VM drive, not shared folder
UBOOT_BUILD_DIR="/mnt/petalinux_projects/u-boot-${UBOOT_BRANCH}"

echo; echo "Running..."; echo

# Checkout the tag from github to local build dir
#git clone --single-branch --branch "${UBOOT_BRANCH}" "${UBOOT_REPO}" "${UBOOT_BUILD_DIR}"

# Configure for zcu102
# Copy customized boot command
cp "${PROJWS}/src/sw/u-boot/config_distro_bootcmd.h" "${UBOOT_BUILD_DIR}/include/"
cp "${PROJWS}/src/sw/u-boot/xilinx_zynqmp_zcu102_rev1_0_defconfig" "${UBOOT_BUILD_DIR}/configs/"

pushd "${UBOOT_BUILD_DIR}"
make xilinx_zynqmp_zcu102_rev1_0_defconfig

# Source petalinux to get the build toolchain
source "${PETALINUX_SETTINGS}"

# Build u-boot
ARCH=aarch64 CROSS_COMPILE=aarch64-none-elf- make

# Copy elf to boot dir
cp u-boot.elf "${BOOT_DIR}/u-boot.elf"

echo; echo "Done"; echo
