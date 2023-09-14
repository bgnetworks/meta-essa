#!bin/bash

# Header structure
#-----------------------------------------------------------------------------------------------
#               |                 |                 |                      |                   |
# MAGIC_WORD    |   keyblob_addr  |  Key blob_len   |   Keyblob_signature  |                   |
#		|		  |		    |	   _addr           |    sign_len       |
#   4 Bytes     |     2 bytes     |    2 bytes      |     2 bytes          |     2 bytes       |
#-----------------------------------------------------------------------------------------------

sign_keyblob_enabled(){
      return 0
}
sign_keyblob_run(){

   mount /dev/mmcblk3p1 /mnt
   # Signing the black key blob with the private key(consider the private key in FAT partition)
   openssl dgst -sha256 -sign /mnt/enckey_signing_private_key.pem -out keyblob.sign /data/caam/enckey.bb 

   # Header for the signed black key blob
   magic_word="\x62\x6c\x62\x6f"
   blob_size=$(printf "%2x\n" $(stat -c %s /data/caam/enckey.bb))
   sign_size=$(printf "%2x\n" $(stat -c %s /keyblob.sign))
   blob_addr="\x00\x0c"
   blob_len="\x00\x$blob_size"
   sign_addr="\x00\x6c"
   sign_len="\x$sign_size"

    # Adding header to signed blob

   echo -e -n $magic_word > signedkeyblob.bin
   echo -e -n $blob_addr >> signedkeyblob.bin
   echo -e -n $blob_len >> signedkeyblob.bin
   echo -e -n $sign_addr >> signedkeyblob.bin
   echo -e -n $sign_len >> signedkeyblob.bin
   #echo -e -n "\x62\x6c\x62\x6f\x00\x0c\x00\x60\x00\x6c\x02\x00" > signedkeyblob.bin 

   # Append the black key blob 
   cat /data/caam/enckey.bb >> signedkeyblob.bin

   # Append the black key blob signature
   cat keyblob.sign >> signedkeyblob.bin 
   
   #copy the signed black key blob to the FAT partition
   cp signedkeyblob.bin /mnt
   
   rm -rf enckey_signing_private_key.pem

   # Todocopy the public key to the FAT partition recived from the host
      
   umount /mnt
}
