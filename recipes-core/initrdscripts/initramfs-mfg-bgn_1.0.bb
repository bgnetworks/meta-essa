SUMMARY = "Manufauturing initramfs image init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
DEPENDS = "virtual/kernel"
RDEPENDS:${PN} = "udev udev-extraconf"
SRC_URI = " \
	file://init-bgn-mfg-boot.sh \
	file://encrypt_rootfs.sh \
	file://extract_rootfs.sh \
"

PR = "r0"

S = "${WORKDIR}"

do_install() {
        install -m 0755 ${WORKDIR}/init-bgn-mfg-boot.sh ${D}/init

	install -d ${D}/init.d

	install -m 0755 ${WORKDIR}/encrypt_rootfs.sh ${D}/init.d/09-encrypt_rootfs
	install -m 0755 ${WORKDIR}/extract_rootfs.sh ${D}/init.d/10-extract_rootfs

	install -d ${D}/dev
        mknod -m 622 ${D}/dev/console c 5 1
}

RRECOMMENDS:${PN}-base += "initramfs-module-lvm"

FILES:${PN} += "/init /dev \
		/init.d/09-encrypt_rootfs \
		/init.d/10-extract_rootfs \
"

# Due to kernel dependency
PACKAGE_ARCH = "${MACHINE_ARCH}"
