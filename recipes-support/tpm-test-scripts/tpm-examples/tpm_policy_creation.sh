#!/bin/bash

# Define the PCR index
pcr_index=16

tpm2_pcrread -o pcr16.dat sha256:$pcr_index

# creating a bin file with the value of zero
dd if=/dev/zero of=pcr_zero.dat bs=32 count=1

#comparing the pcr.dat with pcr_zero.dat file, if the values is not extended means then it will terminated the whole process.
cmp_value=$(cmp -s pcr16.dat pcr_zero.dat; echo $?)

if [ "$cmp_value" -eq 1 ]; then
    echo "PCR value is extended we can proceed further"
else
    echo "PCR value is all zeros, check whether it is the closed board or not."
    rm pcr16.dat
    exit 1
fi

# Start a policy auth session used when authenticating with a policy.
tpm2_startauthsession --policy-session -S session.dat

# Create a policy by using the current state of the pcr
tpm2_policypcr -S session.dat -l sha256:$pcr_index -L policy16.pcr

rm pcr_zero.dat
rm session.dat
rm pcr16.dat
