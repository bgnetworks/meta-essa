# This script shows that the aes key should only be readed from nv memory if the current pcr state gets satisfied.
#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
#user need to define / manually select the nv_index 
nv_index=0x1400002
output_file="aes-key"
aes_key_size=32

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
if tpm2_nvread $nv_index -P pcr:sha256:$pcr_index -s $aes_key_size > $output_file; then
    echo "AES-256 key successfully read from TPM NV index and saved to $output_file."
else
    echo "Error: Reading the TPM NV index failed."
fi