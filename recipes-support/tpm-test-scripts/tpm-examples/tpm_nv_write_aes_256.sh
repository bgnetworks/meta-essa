#!/bin/bash
# This script shows that the aes key should only be written to nv memory if the current pcr state gets satisfied.#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
#user need to define / manually select the nv_index 
nv_index=0x1400002
aes_key_file="aes-256-key"
aes_key_size=32

# Execute tpm2_getcap to get the list of defined NV indexes
defined_nv_indexes=$(tpm2_getcap handles-nv-index)

# Check if the NV index is defined
if [[ $defined_nv_indexes == *"$nv_index"* ]]; then
    echo "NV index $nv_index is defined"
else
    echo "NV index $nv_index is not defined. So defining $nv_index"
    tpm2_nvdefine $nv_index -s $aes_key_size -L policy16.pcr
fi

# Generate a random AES-256 key (32 bytes)
openssl rand -out $aes_key_file $aes_key_size

# Write the AES-256 key to the TPM NV index with the PCR policy, tpm verify internally the pcr.dat is belongs to the mentioned index or not.
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index -i $aes_key_file; then
    echo "AES-256 key successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
    exit 1
fi

# Clean up the temporary AES key file
rm $aes_key_file