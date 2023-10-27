#!/bin/bash

# Define the TPM NV index and PCR index
nv_index=0x1400004
pcr_index=16
segment_size=768

# Execute tpm2_getcap to get the list of defined NV indexes
defined_nv_indexes=$(tpm2_getcap handles-nv-index)

# Check if the NV index is defined
if [[ $defined_nv_indexes == *"$nv_index"* ]]; then
    echo "NV index $nv_index is defined"
else
    echo "NV index $nv_index is not defined. So can't able to read the value from this nv index $nv_index"
    exit 1
fi

# Calculate the size of the key content and determine the segment size
content_size=$(wc -c < key.pem)

# Calculate the number of full segments
segments=$((content_size / segment_size))

# Use a loop to split the key into full segments
for ((i = 0; i < segments; i++)); do
    offset=$((i * segment_size))  # Calculate the offset for the current segment
    # Now, write the current segment to the TPM NV index using the calculated offset
    if tpm2_nvread "$nv_index" -P "pcr:sha256:$pcr_index" -s $segment_size --offset "$offset" > key$i.pem; then
        echo "key1 successfully read from TPM NV index and saved to key$i."
    else
        echo "Error: Reading the TPM NV index failed."
        exit 1
    fi
done

# Handle the remaining bytes if any
remaining_bytes=$((content_size % segment_size))
if [ "$remaining_bytes" -gt 0 ]; then
    offset=$((segments * segment_size))  # Calculate the offset for the remaining bytes
    # Now, write the remaining bytes to the TPM NV index using the calculated offset
    if tpm2_nvread "$nv_index" -P "pcr:sha256:$pcr_index" -s $remaining_bytes --offset "$offset" > key$i.pem; then
        echo "Remaining bytes successfully written key$i"
    else
        echo "Error: Reading the TPM NV index failed."
        exit 1
    fi
fi


# Concatenate the key segments into one key file
cat key0.pem key1.pem key2.pem > key_con_2048.pem

# Remove temporary key files
rm key0.pem
rm key1.pem
rm key2.pem

# Compare the concatenated key with the original key
if cmp -s key_con_2048.pem key.pem; then
    echo "Keys match."

else
    echo "Keys do not match. Error!"
fi
