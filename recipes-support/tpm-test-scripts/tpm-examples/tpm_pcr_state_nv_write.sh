#!/bin/bash

# This script shows that the aes key should only be written to nv memory if the current pcr state gets satisfied.

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
nv_index=0x1400004
aes_key_file="aes-256-key"

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


# Generate a random AES-256 key (32 bytes)
openssl rand -out $aes_key_file 32

# Start a policy auth session used when authenticating with a policy.
tpm2_startauthsession --policy-session -S session1.dat

# PCR Policy gets satisfied by comparing the current state value with the passed-in value; this is done by TPM internally.
if tpm2_policypcr -S session1.dat -l sha256:$pcr_index -f pcr16.dat; then
    echo "Policy PCR16 satisfied."
else
    echo "Policy PCR16 failed. Terminating."
    exit 1
fi

# Create a policy for the current PCR index
tpm2_createpolicy --policy-pcr -l sha256:$pcr_index -L policy16.pcr

# Define the NV index with the policy of the current PCR state
if tpm2_nvdefine $nv_index -L policy16.pcr; then
    echo "NV index defined at the given address with the current PCR state policy."
else
    echo "Error: Defining NV index failed."
    exit 1
fi

# Write the AES-256 key to the TPM NV index with the PCR policy, tpm verify internally thepcr.dat is belongs to the mentioned index or not.
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i $aes_key_file; then
    echo "AES-256 key successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your policy is valid or not."
    exit 1
fi

# Clean up the temporary AES key file
rm $aes_key_file