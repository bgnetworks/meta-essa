# Copyright (c) 2023 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

SUMMARY = "encrypt rootfs package"
LICENSE = "MIT"

# Set the image type to tar.gz
IMAGE_FSTYPES = "tar.gz"

do_install() {
    rootfs_target=$(readlink -f ${DEPLOY_DIR_IMAGE}/core-image-minimal-imx6sxsabresd.tar.bz2)
    mfg_initramfs_target=$(readlink -f ${DEPLOY_DIR_IMAGE}/core-image-minimal-mfg-initramfs-imx6sxsabresd.cpio.gz)
    prod_initramfs_target=$(readlink -f ${DEPLOY_DIR_IMAGE}/core-image-minimal-prod-initramfs-imx6sxsabresd.cpio.gz)
    tar -czf ${DEPLOY_DIR_IMAGE}/encrypted_rootfs_package.tar.gz -C ${DEPLOY_DIR_IMAGE} $(basename $rootfs_target) $(basename $mfg_initramfs_target) $(basename $prod_initramfs_target)
}

# Specify the files to be included in the package
FILES_${PN} += ""

PACKAGES = "${PN}"

