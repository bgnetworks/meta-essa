#!bin/bash

encrypt_rootfs_enabled() {

	mount -o rw /dev/mmcblk3p2 $ROOTFS_DIR

	if ! mountpoint -q $ROOTFS_DIR; then
	   
           fatal "RootFS is already encrypted"
			
       fi

       umount $ROOTFS_DIR
       return 0

}

encrypt_rootfs_run() {
	
	# Creating a encryption key using the caam-keygen
	caam-keygen create enckey ecb -s 16

        # ToDo Send the keyblob to the host pc 

	if [ ! -e /data/caam/enckey ] || [ ! -e /data/caam/enckey.bb ]; then

	       fatal "Failed to create key and key blob"
	fi
	
	# Adding the encryption key in kernel keyring
	cat /data/caam/enckey | keyctl padd logon enckey: @us

        if [ $? -lt 0 ]; then
               fatal "Key is not added to the key ring"
        fi
	
        # Wiping the block to be encrypted
	dd if=/dev/zero of=/dev/mmcblk3p2 bs=1M count=32
	
	# Encrypting the block with CAAM's key
	dmsetup -v create crypt_target --table "0 $(blockdev --getsz /dev/mmcblk3p2) crypt capi:tk(cbc(aes))-plain :36:logon:enckey: 0 /dev/mmcblk3p2 0 1 sector_size:512"
        
        if [ ! -e /dev/mapper/crypt_target ]; then

               fatal "Crypt target is not created"
        fi
	
	# Creating a filesystem on the encrypted block
	mkfs.ext4 /dev/mapper/crypt_target
}
