#!/bin/bash

# Define the PCR index, NV index, and output file for the AES-256 key
pcr_index=16
nv_index=0x1400004

# creating a file
echo "hi everyone" > data.txt

# creating password file 
echo "tpm!123" > password_file

# Create an encrypted RSA private key with the password file
if openssl genrsa -aes256 -passout file:password_file -out private_key.pem 2048; then
    echo "rsa private key is created successfully with the password"
else
    echo "key creation failed"
    exit 1
fi

# Sign the data with the encrypted private key
openssl dgst -sha256 -sign private_key.pem -out signature.bin -passin file:password_file data.txt
echo "data signed successfully"

# Save the PCR16 value to pcr16.dat
tpm2_pcrread -o pcr16.dat sha256:$pcr_index

# Start a policy auth session used when authenticating with a policy.
tpm2_startauthsession --policy-session -S session.dat

# PCR Policy gets satisfied by comparing the current state value with the passed-in value; this is done by TPM internally.
if tpm2_policypcr -S session.dat -l sha256:$pcr_index -f pcr16.dat; then
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

# Write the AES-256 key to the TPM NV index with the PCR policy
if tpm2_nvwrite $nv_index -P pcr:sha256:$pcr_index=pcr16.dat -i password_file; then
    echo "password_file is successfully written to TPM NV index."
else
    echo "Error: Writing to TPM NV index failed. Please create the NV index first or check whether your pcr.dat or pcr_index is valid."
    exit 1
fi

#Clean up temporary files
rm password_file
rm session.dat