#!bin/bash

extract_rootfs_enabled() {
	
        # Mounting the encrypted block to the mount directory
	mount -t ext4 /dev/mapper/crypt_target $ROOTFS_DIR

	if ! mountpoint -q $ROOTFS_DIR; then
	     fatal "Couldn't mount encrypted RootFS"	
	fi
	
	return 0
}

extract_rootfs_run() {

	# Mount the FAT partition for copying the key blob file
	mount /dev/mmcblk3p1 /mnt
	
	# Copying the key blob file to the FAT partition
	cp /data/caam/enckey.bb /mnt/enckey.bb && echo "Took a backup of key blob"
 
        # Extract the rootfs tar file to the mount point
	if [ ! -e /mnt/core-image-minimal-imx6sxsabresd.tar.bz2 ]; then

               fatal "RootFS tarball file missing on boot partition"
	fi

	echo "Extracting RootFS"
	tar -xf /mnt/core-image-minimal-imx6sxsabresd.tar.bz2 -C $ROOTFS_DIR 
        rm -f /mnt/core-image-minimal-imx6sxsabresd.tar.bz2

        # Unmount the mount directories
	umount /mnt
	umount $ROOTFS_DIR
}

