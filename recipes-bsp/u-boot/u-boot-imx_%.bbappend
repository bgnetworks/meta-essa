FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:imx8mmevk = " \
    file://0001-HAB-encrypted-boot.patch \
    file://0002-Add-fastboot-commands.patch \
    ${@bb.utils.contains('TPM_ENABLE', '1', 'file://0003-added_tpm_spi_support.patch', '', d)} \
    ${@bb.utils.contains('TPM_ENABLE', '1', 'file://0004-added_tpm_spi_device_tree_cfg.patch', '', d)} \
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
"
