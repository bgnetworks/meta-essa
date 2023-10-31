#!/bin/bash

#PCR index, NV index, and aes output file for the AES-256 key
incorrect_pcr_index=10
#user need to define / manually select the nv_index 
nv_index=0x1400002
aes_key_file="aes-256-key"
aes_key_size=32

# Generate a random AES-256 key (32 bytes) to overwrite the key  which is already present in the nv index
openssl rand -out $aes_key_file $aes_key_size


# Write the AES-256 key to the TPM NV index with the PCR policy
# input -> given the wrong index value which is not linked with pcr16.dat to produce tpm error.
if tpm2_nvwrite $nv_index -P pcr:sha256:$incorrect_pcr_index -i $aes_key_file; then
    echo "AES-256 key successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not"
fi