#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
#user need to define / manually select the nv_index 
nv_index=0x1400003
#user can modify the passphrase_size
passphrase_size=32

# creating a file
echo "hi everyone" > data.txt

# creating password file 
echo "tpm!123" > password_file

# Create an encrypted RSA private key with the password file
if openssl genrsa -aes256 -passout file:password_file -out private_key.pem 2048; then
    echo "rsa private key is created successfully with the password"
else
    echo "key creation failed"
    exit 1
fi

# Sign the data with the encrypted private key
openssl dgst -sha256 -sign private_key.pem -out signature.bin -passin file:password_file data.txt
echo "data signed successfully"

# Execute tpm2_getcap to get the list of defined NV indexes
defined_nv_indexes=$(tpm2_getcap handles-nv-index)

# Check if the NV index is defined
if [[ $defined_nv_indexes == *"$nv_index"* ]]; then
    echo "NV index $nv_index is defined"
else
    echo "NV index $nv_index is not defined. So defining $nv_index"
    tpm2_nvdefine $nv_index -s $passphrase_size -L policy16.pcr
fi

# Write the AES-256 key to the TPM NV index with the PCR policy
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index -i password_file; then
    echo "password_file is successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your pcr.dat or pcr_index is valid."
    exit 1
fi

#Clean up temporary files
rm password_file
