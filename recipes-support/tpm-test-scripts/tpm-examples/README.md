# TPM Script Examples
This folder contains a collection of shell scripts for working with the Trusted Platform Module (TPM). These scripts demonstrate various TPM commands and their usage.

## Scripts

`tpm_err_aes_nvread.sh` 

This Bash script demonstrates an intentional error scenario involving TPM (Trusted Platform Module) NV (Non-Volatile) Index operations. It showcases how providing an incorrect PCR (Platform Configuration Register) index value can result in an error during TPM NV read.

`tpm_err_aes_nvwrite.sh` 
This script intentionally attempts to overwrite an AES-256 key stored in a TPM2 NV (Non-Volatile) index with an incorrect PCR policy. The script demonstrates the following steps:

1. Defines the PCR index, NV index, and the output file for the AES-256 key.

2. Generates a random AES-256 key (32 bytes) to be used for overwriting the key stored in the TPM NV index.

3. Attempts to write the generated AES-256 key to the TPM NV index using an incorrect PCR policy.

4. In the event of a policy error, the script will display an error message, as the provided PCR index is not linked with the expected PCR state file (pcr16.dat).

`tpm_policy_creation.sh`

This script shows how to create policies and define nv indexes for key storage.
The script performs the following steps:

1.Verifying the existence of the file to be checked, pcr_extend.dat, in the script directory.If not, it will create(used for measured boot)
2. Verifying whether the script directory contains the pcr16.dat (pcr output file) or not.
3. Checking whether the pcr is extended or not. If extended it will proceed further otherwise the process should terminated.
4.If the pcr_extend.dat and pcr16.dat files match, the measured boot passes, and the operation can continue.
5. PCR Policy gets satisfied by comparing the current state value with the passed-in value; this is done by TPM internally.
6. Creates a policy based on the satisfied PCR policy for pcr16.dat
7. Defines an NV (Non-Volatile) index in the TPM with the created PCR policy.

`tpm_nv_write_aes_256.sh`

This script demonstrates how to securely store an AES-256 key in TPM2 NV memory based on the satisfaction of a PCR (Platform Configuration Register) policy. The script performs the following steps:

1. creating an 32 byte aes key using openssl
2. Writes the AES-256 key to the TPM NV index, ensuring that the key is only written if the PCR policy is satisfied.

`tpm_nv_read_aes_256.sh`
This script demonstrates how to securely retrieve an AES-256 key from TPM2 NV (Non-Volatile) memory based on the satisfaction of a PCR (Platform Configuration Register) policy. The script performs the following steps:

Defines the PCR index, NV index, and the output file for the AES-256 key.
Reads the AES-256 key from the TPM NV index with the specified PCR policy.
If the PCR policy is satisfied, the script successfully retrieves the AES-256 key and saves it to the specified output file.

`tpm_nv_write_rsa_2048.sh`

This script demonstrates how to securely store an rsa-2048 key in TPM2 NV memory based on the satisfaction of a PCR policy. The script performs the following steps:

1. creating an rsa key with 2048 bits length
2. Calculate the size of the key content and split it into three segments
3. Write the segments to the TPM NV index with the PCR policy, tpm verify internally the pcr.dat is belongs to the mentioned index or not.
4. And removing all the segments.


`tpm_nv_read_rsa_2048.sh`

This script demonstrates how to securely retrieve an rsa-2048 bit key from TPM2 NV (Non-Volatile) memory based on the satisfaction of a PCR (Platform Configuration Register) policy

The script will perform the following steps:

1. Read key segments one by one from the TPM NV index with the specified PCR policy.
2. Save key segments as separate files (key1.pem, key2.pem, key3.pem).
3. Concatenate the key segments into one key file (key_con_2048.pem).
4. Compare the concatenated key with the original key (key.pem).
5. Display whether the keys match or not.


## Usage
Run the scripts:
```
./tpm_policy_creation.sh
./tpm_nv_write_rsa_2048.sh
./tpm_nv_read_rsa_2048.sh
./tpm_nv_write_aes_256.sh
./tpm_nv_read_aes_256.sh
./tpm_err_aes_nvwrite.sh
./tpm_err_aes_nvread.sh
```

### Notes:
Replace placeholders like `hash of file` and `data` with actual values before running the scripts.

Ensure that you have the necessary `TPM tools` and permissions to run these scripts.
