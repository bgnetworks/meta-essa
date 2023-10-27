#!bin/bash

# Header structure
#-----------------------------------------------------------------------------------------------
#               |                 |                 |                      |                   |
# MAGIC_WORD    |   keyblob_offset|  Key blob_len   |   Keyblob_signature  |                   |
#		|		  |		    |	   _offset         | signature_length  |
#   4 Bytes     |     2 bytes     |    2 bytes      |     2 bytes          |     2 bytes       |
#-----------------------------------------------------------------------------------------------

sign_keyblob_enabled(){
      return 0
}
sign_keyblob_run(){

   mount /dev/mmcblk3p1 /mnt
   
   # Check key is exist in the mnt point
   if [ ! -e /mnt/enckey_signing_private_key.pem ]; then
   	fatal "Encryption key not available"
   fi
   
   # Signing the black key blob with the private key(consider the private key in FAT partition)
   openssl dgst -sha256 -sign /mnt/enckey_signing_private_key.pem -out keyblob.sign /data/caam/enckey.bb 

   # Header information for the signed black key blob
   header_size=12
   magic_word="blob"
   blob_offest=$(printf "%02x" "$header_size" | xxd -r -p) 
   blob_size=$(stat -c %s /data/caam/enckey.bb)
   blob_length=$(printf "%02x" "$blob_size" | xxd -r -p)

   signature_location=$((blob_size + header_size))
   signature_offest=$(printf "%02x" "$signature_location" | xxd -r -p)
   signature_size=$(stat -c %s /keyblob.sign)
   signature_length=$(printf "%04X" $signature_size)

   
   # Appending the header information  
   echo -e -n "$magic_word" > signedkeyblob.bin
   echo -e -n "\x00$blob_offest" >> signedkeyblob.bin 
   echo -e -n "\x00$blob_length" >> signedkeyblob.bin
   echo -e -n "\x00$signature_offest" >> signedkeyblob.bin
   echo -e -n "\x${signature_length:0:2}\x${signature_length:2:2}" >> signedkeyblob.bin

   # Append the black key blob 
   cat /data/caam/enckey.bb >> signedkeyblob.bin

   # Append the black key blob signature
   cat keyblob.sign >> signedkeyblob.bin 
   
   # copy the signed black key blob to the FAT partition
   cp signedkeyblob.bin /mnt
   
   # Extract public key from private key pair
   openssl rsa -in /mnt/enckey_signing_private_key.pem -pubout -out /mnt/enckey_signing_public_key.pem
   
   #Remove the private key used for signing the key blob 
   rm -rf /mnt/enckey_signing_private_key.pem

   #Remove the black key and black key blob
    rm -rf /data/caam/enckey
    rm -rf /data/caam/enckey.bb
      
   umount /mnt
}
