FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:imx8mmevk = " \
    file://0001-HAB-encrypted-boot.patch \
    file://0002-Add-fastboot-commands.patch \
"

SRC_URI:append:imx6ulevk = " \
    file://0001-Enable-secure-boot-support.patch \
    file://0002-Enable-encrypted-boot-support.patch \
    file://0003-Add-fastboot-commands.patch \
"

SRC_URI:append:imx6sxsabresd = " \
    file://0001-Enable-secure-boot-support.patch \
    file://0002-Enable-QSPI-boot-support.patch \
    file://0003-Enable-encrypted-boot-support.patch \
    file://0004-Add-fastboot-commands.patch \
"

SRC_URI:append:iot-gate-imx8 = " \
    file://0001-Add-SDP-support.patch \
    file://0002-Enable-HAB-features.patch \
    file://0003-Add-fastboot-commands.patch \
"
