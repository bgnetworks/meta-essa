#!/bin/bash

# This script shows that the aes key should only be readed from nv memory if the current pcr state gets satisfied.

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
nv_index=0x1400004
output_file="aes-key"

# Read the AES-256 key from the TPM NV index with the specified PCR policy
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 768 > $output_file; then
    echo "AES-256 key successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed."
fi
