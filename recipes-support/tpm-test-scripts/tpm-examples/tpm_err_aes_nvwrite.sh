#!/bin/bash
#R index, NV index, and aes output file for the AES-256 key
pcr_index=10
nv_index=0x1400004
aes_key_file="aes-256-key"

# Generate a random AES-256 key (32 bytes) to overwrite the key  which is already present in the nv index
openssl rand -out $aes_key_file 32

# Save the PCR16 value to pcr16.dat
tpm2_pcrread -o pcr16.dat sha256:$pcr_index

# Write the AES-256 key to the TPM NV index with the PCR policy
# input -> given the wrong index value which is not linked with pcr16.dat to produce tpm error.
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i $aes_key_file; then
    echo "AES-256 key successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not"
fi