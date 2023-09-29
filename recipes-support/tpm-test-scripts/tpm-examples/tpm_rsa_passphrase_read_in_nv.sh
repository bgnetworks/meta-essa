#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
nv_index=0x1400004

# Read the AES-256 key from the TPM NV index with the specified PCR policy
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 768 > password_retrived; then
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
# Undefining the nv index
tpm2_nvundefine $nv_index