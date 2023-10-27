#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
#user need to define / manually select the nv_index 
nv_index=0x1400003
#user can modify the passphrase_size
passphrase_size=32
# Execute tpm2_getcap to get the list of defined NV indexes
defined_nv_indexes=$(tpm2_getcap handles-nv-index)

# Check if the NV index is defined
if [[ $defined_nv_indexes == *"$nv_index"* ]]; then
    echo "NV index $nv_index is defined"
else
    echo "NV index $nv_index is not defined. So can't able to read the value from this nv index $nv_index"
    exit 1
fi

# Read the AES-256 key from the TPM NV index with the specified PCR policy
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s $passphrase_size > password_retrived; then
    echo "password_retrived file is successfully readed from TPM NV index and saved to password_retrived."
else
    echo "Error: Reading the TPM NV index failed."
    exit 1
fi

# Decrypt the private key
openssl rsa -in private_key.pem -out unencrypted_private_key.pem -passin file:password_retrived

# Extract the corresponding public key
openssl rsa -in unencrypted_private_key.pem -pubout -out public_key.pem

# Verify the signature using the public key
if openssl dgst -sha256 -verify public_key.pem -signature signature.bin data.txt; then
    echo "Signature verified successfully."
else
    echo "Signature verification failed."
    exit 1
fi

# Clean up temporary files
rm unencrypted_private_key.pem
rm public_key.pem
#rm password_retrived

echo "Script execution complete."
