#!/bin/bash

# Define the TPM NV index and PCR index
#user need to define / manually select the nv_index 
nv_index=0x1400004   
pcr_index=16
segment_size=768

# Execute tpm2_getcap to get the list of defined NV indexes
defined_nv_indexes=$(tpm2_getcap handles-nv-index)

# Check if the NV index is defined
if [[ $defined_nv_indexes == *"$nv_index"* ]]; then
    echo "NV index $nv_index is defined"
else
    echo "NV index $nv_index is not defined. So defining $nv_index"
    tpm2_nvdefine $nv_index -L policy16.pcr
fi

# Generate an RSA key with a length of 2048 bits
openssl genrsa -out key.pem 2048
 
# Calculate the size of the key content and determine the segment size
content_size=$(wc -c < key.pem)

# Calculate the number of full segments
segments=$((content_size / segment_size))

# Use a loop to split the key into full segments
for ((i = 0; i < segments; i++)); do
    offset=$((i * segment_size))  # Calculate the offset for the current segment
    dd if=key.pem of=segment"$i".pem bs=1 skip="$offset" count="$segment_size"

    # Now, write the current segment to the TPM NV index using the calculated offset
    if tpm2_nvwrite "$nv_index" -P "pcr:sha256:$pcr_index" -i "segment$i.pem" --offset "$offset"; then
        echo "Segment $i successfully written to TPM NV index."
    else
        echo "Error: Writing segment $i to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
        exit 1
    fi
done

# Handle the remaining bytes if any
remaining_bytes=$((content_size % segment_size))
if [ "$remaining_bytes" -gt 0 ]; then
    offset=$((segments * segment_size))  # Calculate the offset for the remaining bytes
    dd if=key.pem of=segment"$segments".pem bs=1 skip="$offset" count="$remaining_bytes"

    # Now, write the remaining bytes to the TPM NV index using the calculated offset
    if tpm2_nvwrite "$nv_index" -P "pcr:sha256:$pcr_index" -i "segment$segments.pem" --offset "$offset"; then
        echo "Remaining bytes successfully written to TPM NV index."
    else
        echo "Error: Writing remaining bytes to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
        exit 1
    fi
fi

# Remove temporary segment files
rm segment0.pem
rm segment1.pem
rm segment2.pem
