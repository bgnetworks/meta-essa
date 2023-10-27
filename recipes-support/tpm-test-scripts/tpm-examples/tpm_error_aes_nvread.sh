#!/bin/bash

#PCR index, NV index, and output file for the AES-256 key
incorrect_pcr_index=10
#user need to define / manually select the nv_index 
nv_index=0x1400002
aes_key_size=32

output_file="aes-key"

# Read the AES-256 key from the TPM NV index with the wrong PCR index to produce tpm error.
if tpm2_nvread $nv_index -P pcr:sha256:$incorrect_pcr_index -s $aes_key_size > $output_file; then
    echo "AES-256 key successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed because of wrong PCR index value."
fi