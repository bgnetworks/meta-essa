#!bin/bash

extract_rootfs_enabled() {

	mount -t ext4 /dev/mapper/crypt_target $ROOTFS_DIR

	if mountpoint -q $ROOTFS_DIR; then
		return 0
	fi
	
	echo "Couldn't mount encrypted RootFS"
	return 1
}

extract_rootfs_run() {

	mount /dev/mmcblk3p1 /mnt

	cp /data/caam/enckey.bb /mnt/enckey.bb && echo "Took a backup of key blob"

	if [ -e /mnt/core-image-minimal-imx6sxsabresd.tar.bz2 ]; then

		echo "Extracting RootFS"
		tar -xf /mnt/core-image-minimal-imx6sxsabresd.tar.bz2 -C $ROOTFS_DIR && rm -f /mnt/core-image-minimal-imx6sxsabresd.tar.bz2

	else

		echo "RootFS tarball file missing on boot partition"
		return 1

	fi

	umount /mnt
	umount $ROOTFS_DIR

}

