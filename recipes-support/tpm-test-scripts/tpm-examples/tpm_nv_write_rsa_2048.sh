#!/bin/bash

# Define the TPM NV index and PCR index
nv_index=0x1400002
pcr_index=16

# Save the PCR16 value to pcr16.dat
tpm2_pcrread -o pcr16.dat sha256:$pcr_index

# creating a bin file with the value of zero
dd if=/dev/zero of=pcr_zero.dat bs=32 count=1

#comparing the pcr.dat with pcr_zero.dat file, if the values is not extended means then it will terminated the whole process.
cmp_value=$(cmp -s pcr16.dat pcr_zero.dat; echo $?)

if [ "$cmp_value" -eq 1 ]; then
    echo "PCR value is extended we can proceed further"
else
    echo "PCR value is all zeros, check whether it is the closed board or not."
    exit 1
fi

# Generate an RSA key with a length of 2048 bits
openssl genrsa -out key.pem 2048

# Calculate the size of the key content and split it into three segments
content_size=$(wc -c < key.pem)
segment_size=$((content_size / 3))
dd if=key.pem of=segment1.pem bs=1 count=$segment_size
dd if=key.pem of=segment2.pem bs=1 skip=$segment_size count=$segment_size
dd if=key.pem of=segment3.pem bs=1 skip=$((2 * $segment_size))

# Start a policy auth session used when authenticating with a policy.
tpm2_startauthsession --policy-session -S session1.dat

# PCR Policy gets satisfied by comparing the current state value with the passed-in value; this is done by TPM internally.
if tpm2_policypcr -S session1.dat -l sha256:$pcr_index -f pcr16.dat; then
    echo "Policy PCR16 satisfied."
else
    echo "Policy PCR16 failed. Terminating."
    exit 1
fi


# creating the policy for the specific nv index.
tpm2_createpolicy --policy-pcr -l sha256:$pcr_index -L policy16.pcr

# Define the NV index with the policy of the current PCR state
if tpm2_nvdefine $nv_index -L policy16.pcr; then
    echo "NV index defined at the given address with the current PCR state policy."
else
    echo "Error: Defining NV index failed."
    exit 1
fi


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
rm session1.dat