#!bin/bash

decrypt_rootfs_enabled() {

	return 0
}

decrypt_rootfs_run() {

	# Import the key
	caam-keygen import $KEYS_DIR/enckey.bb importKey

	# Check if importKey exists
	if [ ! -e /data/caam/importKey ]; then
		fatal "importKey file not found"
	fi

	# Add the key to the keyring
	cat /data/caam/importKey | keyctl padd logon logkey: @us

	# Check if keyctl command was successful
	if [ $? -ne 0 ]; then
		fatal "keyctl command failed"
	fi

       # Create the crypt_target using dmsetup
	dmsetup -v create crypt_target --table "0 $(blockdev --getsz "$ROOTFS_PARTITION") crypt capi:tk(cbc(aes))-plain :36:logon:logkey: 0 $ROOTFS_PARTITION 0 1 sector_size:512"

       # Check if dmsetup command was successful
       if [ ! -e /dev/mapper/crypt_target ]; then

               fatal "Crypt target is not created"
       fi

       # Mount the decrypted filesystem to $ROOTFS_DIR
       mount -t ext4 /dev/mapper/crypt_target "$ROOTFS_DIR"

       # Check if can we mount encrypted root partition
       if ! mountpoint -q $ROOTFS_DIR; then
		fatal "Couldn't mount encrypted RootFS parition"
       fi
}
