#!bin/bash

# Header structure
#-----------------------------------------------------------------------------------------------
#               |                 |                 |                      |                   |
# MAGIC_WORD    |   keyblob_offset|  Key blob_len   |   Keyblob_signature  |                   |
#		|		  |		    |	   _offset         | signature_length  |
#   4 Bytes     |     2 bytes     |    2 bytes      |     2 bytes          |     2 bytes       |
#-----------------------------------------------------------------------------------------------

extract_keyblob_enabled() {

	return 0
}

extract_keyblob_run() {

      header_size=12
      dd if=$KEYS_DIR/signedkeyblob.bin of=$KEYS_DIR/header_info.bin bs=1 count=$header_size
      xxd -p $KEYS_DIR/header_info.bin > $KEYS_DIR/header_info_hex
      header_info=$(cat $KEYS_DIR/header_info_hex)
      
      # Convert the magic word 'blob' from hex to characters
      magic_word_hex="${header_info:0:8}"
      magic_word=$(echo -n "$magic_word_hex" | xxd -r -p)

     # Verify the magic word
      if [ "$magic_word" != "blob" ]; then
         fatal "Magic word does not match!"
      fi

    # Extract and convert other values with reference to Header structure
      blob_offset_hex="${header_info:8:4}"
      blob_size_hex="${header_info:12:4}"
      signature_offset_hex="${header_info:16:4}"
      signature_len_hex="${header_info:20:4}"

     # Convert hex values to decimal
      blob_offset=$((16#${blob_offset_hex}))
      blob_length=$((16#${blob_size_hex}))
      signature_offset=$((16#${signature_offset_hex}))
      signature_length=$((16#${signature_len_hex}))
  
     # Extract the keyblob from the combined image
      dd if=$KEYS_DIR/signedkeyblob.bin of=$KEYS_DIR/enckey.bb bs=1 skip=$blob_offset count=$blob_length
      
    # Extract the signature from the combined image
      dd if=$KEYS_DIR/signedkeyblob.bin of=$KEYS_DIR/keyblob_signature.sign bs=1 skip=$signature_offset count=$signature_length

    # Verify the signature with the public key
      auth_status=$(openssl dgst -verify $KEYS_DIR/enckey_signing_public_key.pem -keyform PEM -sha256 -signature $KEYS_DIR/keyblob_signature.sign -binary $KEYS_DIR/enckey.bb)
      if [ "$auth_status" != "Verified OK" ]; then
            rm -rf $KEYS_DIR/enckey.bb
	    fatal "Authentication failed"
      fi
      
}
