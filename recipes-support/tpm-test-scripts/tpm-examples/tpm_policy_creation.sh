#!/bin/bash

# Define the PCR index
pcr_index=16

#script is located
script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the filename you want to check
file_to_check="measured.pcrvalues"

# Combine the directory and the filename
file_path="$script_directory/$file_to_check"

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

if [ -e "$file_path" ]; then
  echo "File $file_to_check exists in the script's directory."
else
  echo "File $file_to_check does not exist in the script's directory, creating measured.pcrvalues file."
  cp pcr16.dat measured.pcrvalues
fi

# Start a policy auth session used when authenticating with a policy.
tpm2_startauthsession --policy-session -S session1.dat

# Measured boot check using tpm2_policypcr api carried out by comparing current state value with the measured.pcrvalues value; this is done by TPM internally.
if tpm2_policypcr -S session1.dat -l sha256:$pcr_index -f $file_to_check; then
    echo "PCR value is extended and Passes the Measure Boot condition."
else
    echo "PCR values are not matching, Measure Boot fails"
    exit 1
fi

# Create a policy for the current PCR index
tpm2_createpolicy --policy-pcr -l sha256:$pcr_index -L policy16.pcr
echo "policy created"

rm pcr_zero.dat
rm session1.dat