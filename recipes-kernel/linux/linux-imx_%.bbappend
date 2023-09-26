# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Dm-crypt fragment for 5.10 kernel
SRC_URI:append = " \
    file://0001-device-mapper-and-crypt-target.cfg \
    file://0002-caam-black-key-driver.cfg \
    file://0003-cryptographic-API-functions.cfg \
"

SRC_URI:append:imx8mmevk = " \
    file://0004-added_spi_tpm_device_tree_cfg.patch \
    file://0005-enable_tpm_cfg.cfg \
"

SRC_URI:append:imx6sxsabresd = " \
    file://0001-Fix-CAAM-RNG.patch \
"

do_configure:append() {
    cat ../*.cfg >>${B}/.config
}
