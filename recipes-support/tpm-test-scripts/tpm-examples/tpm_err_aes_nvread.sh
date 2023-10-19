#!/bin/bash

#PCR index, NV index, and output file for the AES-256 key
pcr_index=10
nv_index=0x1400004
output_file="aes-key"

# Read the AES-256 key from the TPM NV index with the wrong PCR index to produce tpm error.
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 768 > $output_file; then
    echo "AES-256 key successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed because of wrong PCR index value."
fi