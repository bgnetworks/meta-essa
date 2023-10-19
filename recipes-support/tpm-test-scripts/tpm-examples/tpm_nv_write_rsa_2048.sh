#!/bin/bash

# Define the TPM NV index and PCR index
nv_index=0x1400004
pcr_index=16

# Generate an RSA key with a length of 2048 bits
openssl genrsa -out key.pem 2048

# Calculate the size of the key content and split it into three segments
content_size=$(wc -c < key.pem)
segment_size=$((content_size / 3))
dd if=key.pem of=segment1.pem bs=1 count=$segment_size
dd if=key.pem of=segment2.pem bs=1 skip=$segment_size count=$segment_size
dd if=key.pem of=segment3.pem bs=1 skip=$((2 * $segment_size))

# Write the segments to the TPM NV index with the PCR policy, tpm verify internally the pcr.dat is belongs to the mentioned index or not.
# Write the key segments to the NV index with the verified PCR policy
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i segment1.pem; then
    echo "segment1 successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
    exit 1
fi

if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i segment2.pem --offset 569; then
    echo "segment2 successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
    exit 1
fi

if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i segment3.pem --offset 1137; then
    echo "segment3 successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
    exit 1
fi

# Remove temporary segment files
rm segment1.pem
rm segment2.pem
rm segment3.pem