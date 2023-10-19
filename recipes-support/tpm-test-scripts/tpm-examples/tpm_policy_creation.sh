#!/bin/bash

# Define the PCR index, NV index
pcr_index=16
nv_index=0x1400004

#script is located
script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the filename you want to check
file_to_check="pcr_extend.dat"
pcr_file="pcr16.dat"

# Combine the directory and the filename
file_path="$script_directory/$file_to_check"
pcr_file_path="$script_directory/$pcr_file"

if [ -e "$file_path" ]; then
  echo "File $file_to_check exists in the script's directory."
else
  echo "File $file_to_check does not exist in the script's directory, creating pcr extended file."
  tpm2_pcrread -o pcr16.dat sha256:$pcr_index
  cp pcr16.dat pcr_extend.dat
fi

if [ -e "$pcr_file_path" ]; then
  echo "File $pcr_file exists in the script's directory."
else
  echo "File $pcr_file does not exist in the script's directory, creating pcr file."
  tpm2_pcrread -o pcr16.dat sha256:$pcr_index
fi

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

cmpare_value=$(cmp -s $file_to_check pcr16.dat; echo $?)

if [ "$cmpare_value" -eq 1 ]; then
    echo "PCR values are not same, Measure Boot fails"
    exit 1
else
    echo "PCR value is extended and Passes the Measure Boot condition."
fi

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

rm pcr_zero.dat
rm session1.dat