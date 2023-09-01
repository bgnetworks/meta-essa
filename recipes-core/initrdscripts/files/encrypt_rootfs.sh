#!bin/bash

encrypt_rootfs_enabled() {
	mount /dev/mmcblk3p2 $ROOTFS_DIR

	if mountpoint -q $ROOTFS_DIR; then
		umount $ROOTFS_DIR
		return 0
	fi

	echo "RootFS is already encrypted"
	return 1

}

encrypt_rootfs_run() {

	caam-keygen create enckey ecb -s 16

	if [ ! -e /data/caam/enckey ] || [ ! -e /data/caam/enckey.bb ]; then
		echo "Failed to create key and key blob"
		return 1
	fi

	cat /data/caam/enckey | keyctl padd logon enckey: @us

	dd if=/dev/zero of=/dev/mmcblk3p2 bs=1M count=32

	dmsetup -v create crypt_target --table "0 $(blockdev --getsz /dev/mmcblk3p2) crypt capi:tk(cbc(aes))-plain :36:logon:enckey: 0 /dev/mmcblk3p2 0 1 sector_size:512"

	mkfs.ext4 /dev/mapper/crypt_target
}
