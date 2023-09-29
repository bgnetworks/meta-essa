#!/bin/bash

# Define the TPM NV index and PCR index
nv_index=0x1400002
pcr_index=16

# Read the key segments from the NV index and save them as separate key files
# Read the segments from the TPM NV index with the specified PCR policy and stored in files.
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 568 > key1.pem; then
    echo "key1 successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed."
    exit 1
fi

if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 568 --offset 569 > key2.pem; then
    echo "key2 successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed."
    exit 1
fi

if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s 568 --offset 1137 > key3.pem; then
    echo "key3 successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed."
    exit 1
fi

# Concatenate the key segments into one key file
cat key1.pem key2.pem key3.pem > key_con_2048.pem

# Remove temporary key files
rm key1.pem
rm key2.pem
rm key3.pem

# Compare the concatenated key with the original key
if cmp -s key_con_2048.pem key.pem; then
    echo "Keys match. Undefining the NV index."

else
    echo "Keys do not match. Error!"
fi

# undefining the nv index
tpm2_nvundefine $nv_index