#!bin/bash

verify_key_enabled() {

	mount -o rw /dev/mmcblk3p1 $KEYS_DIR

	if ! mountpoint -q $KEYS_DIR; then
		fatal "Issue with mount to the partition contains key"
	fi

	if [ ! -e $KEYS_DIR/enckey_signing_public_key.pem ]; then
		fatal "Public key for signing the key blob is not available!"
	fi

	return 0
}

verify_key_run() {
	
	# Read the /proc/cmdline output into a variable
	cmdline=$(cat /proc/cmdline)
        # Extract the hash value from the environment variable
        hash_value_kernelargs=$(echo "$cmdline" | grep -o 'hash=[^ ]*' | cut -d '=' -f 2)

        # convert to the binary and add in the binary file
        public_key_hash=$(echo "$hash_value_kernelargs" | xxd -r -p)
        echo -n "$public_key_hash" > $KEYS_DIR/publickey_hash.bin 
	
	# Get the hash value for the public key stored in the FAT partition
	openssl dgst -binary -out $KEYS_DIR/enckey_signing_publickey_hash.bin $KEYS_DIR/enckey_signing_public_key.pem	

	# Compare calculated hash and hash from kernel_args
	if ! cmp -s $KEYS_DIR/publickey_hash.bin $KEYS_DIR/enckey_signing_publickey_hash.bin; then
  	     fatal "Public key hash not matched"
        fi
}
