SUMMARY = "Production image init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DEPENDS = "virtual/kernel"
RDEPENDS_${PN} = "udev udev-extraconf bash"
SRC_URI = " \
	file://init-bgn-prod-boot.sh \
	file://verify_key.sh \
	file://extract_keyblob.sh \
        file://decrypt_rootfs.sh \
	file://finish.sh \
"

PR = "r0"

S = "${WORKDIR}"

do_install() {
	install -m 0755 ${WORKDIR}/init-bgn-prod-boot.sh ${D}/init

	install -d ${D}/init.d

	install -m 0755 ${WORKDIR}/verify_key.sh ${D}/init.d/10-verify_key
        install -m 0755 ${WORKDIR}/extract_keyblob.sh ${D}/init.d/11-extract_keyblob
        install -m 0755 ${WORKDIR}/decrypt_rootfs.sh ${D}/init.d/12-decrypt_rootfs
	install -m 0755 ${WORKDIR}/finish.sh ${D}/init.d/13-finish

	install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

RRECOMMENDS:${PN}-base += "initramfs-module-lvm"

FILES:${PN} += "/init /dev \
		/init.d/10-verify_key \
                /init.d/11-extract_keyblob \
                /init.d/12-decrypt_rootfs \
		/init.d/13-finish \
"

# Due to kernel dependency
PACKAGE_ARCH = "${MACHINE_ARCH}"
