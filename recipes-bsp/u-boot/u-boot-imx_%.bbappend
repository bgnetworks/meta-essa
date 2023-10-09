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
    ${@bb.utils.contains('ESSA_BOOT_MEDIUM', 'QSPI', 'file://0002-Enable-QSPI-boot-support.patch', '', d)} \
    file://0003-Enable-encrypted-boot-support.patch \
    file://0004-Add-fastboot-commands.patch \
    file://0005-Setting-U-Boot-env-to-load-rootfs-from-initramfs-6sx.patch \
    file://0006-Added-u-boot-command-for-variable-append.patch \
    file://0007-Add-steps-to-extract-hash-from-kernel-args.patch \
"

#SRC_URI:append:iot-gate-imx8 = " \
#    file://0001-Add-SDP-support.patch \
#    file://0002-Enable-HAB-features.patch \
#    file://0003-Add-fastboot-commands.patch \
#"
