FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:imx8mmevk = " \
    file://0001-Add-SPL-offset-in-IVT.patch \
    "

do_compile() {
    compile_${SOC_FAMILY}
    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin                       ${BOOT_STAGING}

        bbnote "Create a dummy DEK blob"
        dd if=/dev/zero of=${BOOT_STAGING}/dek_blob_fit_dummy.bin bs=96 count=1 conv=fsync
    fi
    # mkimage for i.MX8
    for target in ${IMXBOOT_TARGETS}; do
        if [ "$target" = "flash_linux_m4_no_v2x" ]; then
           # Special target build for i.MX 8DXL with V2X off
           bbnote "building ${SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
           make SOC=${SOC_TARGET} ${REV_OPTION} V2X=NO  flash_linux_m4
        else
           bbnote "building ${SOC_TARGET} - ${REV_OPTION} ${target}"
           make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} dtbs=${UBOOT_DTB_NAME} ${target}
        fi
        if [ -e "${BOOT_STAGING}/flash.bin" ]; then
            cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
        fi
    done
}

do_deploy:append() {
    cp ${LOGDIR}/log.do_compile ${DEPLOYDIR}/compile.log
}

LOGDIR ?= "${WORKDIR}/temp"
