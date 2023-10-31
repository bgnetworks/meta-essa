# TPM Script Examples
This folder contains a collection of shell scripts for working with the Trusted Platform Module (TPM). These scripts demonstrate various TPM commands and their usage.

## Scripts

`tpm_error_aes_nvread.sh` 

This Bash script demonstrates an intentional error scenario involving TPM (Trusted Platform Module) NV (Non-Volatile) Index operations. It showcases how providing an incorrect PCR (Platform Configuration Register) index value can result in an error during TPM NV read.

`tpm_error_aes_nvwrite.sh` 
This script intentionally attempts to overwrite an AES-256 key stored in a TPM2 NV (Non-Volatile) index with an incorrect PCR policy. The script demonstrates the following steps:

1. Defines the PCR index, NV index, and the output file for the AES-256 key.

2. Generates a random AES-256 key (32 bytes) to be used for overwriting the key stored in the TPM NV index.

3. Attempts to write the generated AES-256 key to the TPM NV index using an incorrect PCR policy.

4. In the event of a policy error, the script will display an error message, as the provided PCR index is not linked with the expected PCR state file (pcr16.dat).

`tpm_policy_creation.sh`

This script demonstrates how to create policies

1. Checking whether the pcr is extended or not. If extended it will proceed further otherwise the process should terminated.
2. Create a policy by using the current state of the PCR.

`tpm_check_measured_boot.sh`

This script check the measure boot condition. 

1. Checking whether the pcr is extended or not. If extended it will proceed further otherwise the process should terminated.
2. Verifying the existence of the file to be checked (i.e) measured.pcrvalues, in the script directory.If not, it will create measured.pcrvalues and also the reboot is required.
3. Measured boot check using tpm2_policypcr api carried out by comparing current state value with the measured.pcrvalues value; this is done by TPM internally.

`tpm_nv_write_aes_256.sh`

This script demonstrates how to securely store an AES-256 key in TPM2 NV memory based on the satisfaction of a PCR (Platform Configuration Register) policy. The script performs the following steps:

1. By using the get cap command, to get the list of defined nv index
2. From the nv index list, If the mentioned nv address is not in the list it will create the nv index for the mentioned address.
3. creating an 32 byte aes key using openssl
4. Writes the AES-256 key to the TPM NV index, ensuring that the key is only written if the PCR policy is satisfied.

`tpm_nv_read_aes_256.sh`
This script demonstrates how to securely retrieve an AES-256 key from TPM2 NV (Non-Volatile) memory based on the satisfaction of a PCR (Platform Configuration Register) policy. The script performs the following steps:

1. Defines the PCR index, NV index, and the output file for the AES-256 key. 
2. By using the get cap command, to get the list of defined nv index
3. If the mentioned nv index is not defined, we will define the nv index.
4. Reads the AES-256 key from the TPM NV index with the specified PCR policy. If the PCR policy is satisfied, the script successfully retrieves the AES-256 key and saves it to the specified output file.

`tpm_nv_write_rsa_2048.sh`

This script demonstrates how to securely store an rsa-2048 key in TPM2 NV memory based on the satisfaction of a PCR policy.

The script performs the following steps:

1. By using the get cap command, to get the list of defined nv index.
2. From the nv index list, If the mentioned nv address is not in the list it will create the nv index for the mentioned address with the current state value.
3. Calculate the size of the key content and also the number of full segments
4. Use a loop to split the key into full segments and write the key in mentioned TPM index, ensuring that the key is only written if the PCR policy is satisfied.
5. Also writes the remaining bytes if any in the mentioned TPM index.

`tpm_nv_read_rsa_2048.sh`

This script demonstrates how to securely retrive a rsa key from NV memory based on the satisfaction of a PCR.

The script performs the following steps:

1. By using the get cap command, to get the list of defined nv index.
2. If the mentioned nv index is not defined, we will define the nv index.
3. Calculate the size of the key content and also the number of full segments
4. Using a loop,  to read the full segments key from the mentioned nv Index.
5. And also read the remaining segments key from the mentioned nv Index.

`tpm_nv_passphrase_write.sh`

This script demonstrates how to securely store an passphrase from NV memory based on the satisfaction of a PCR.

The script performs the following steps:

1. Creating an data and passphrase file
2. Generate the rsa key with the created passphrase.
3. Sign the data with the encrypted private key.
4. By using the get cap command, to get the list of defined nv index.
5. If the mentioned nv index is not defined, we will define the nv index.
6. From the nv index list, If the mentioned nv address is not in the list it will create the nv index for the mentioned address with the current state Pcr value.
6. Writes the passphrase to the TPM NV index, ensuring that the passphrase is only written if the PCR policy is satisfied.

`tpm_nv_passphrase_read.sh`

This script demonstrates how to securely retrive a passphrase from NV memory based on the satisfaction of a PCR.

The script performs the following steps:

1. By using the get cap command, to get the list of defined nv index.
2. If the mentioned nv index is not defined, we will define the nv index.
3. Reads the passphrase from the TPM NV index with the specified pcr index.
4. Then decrypt the encrypted private key with the passphrase file.
5. By using decrypt private key, Extract the corresponding public key.
6. Verify the signature using the public key.

## Usage
Run the scripts:
```
./tpm_policy_creation.sh
./tpm_check_measured_boot.sh
./tpm_nv_write_rsa_2048.sh
./tpm_nv_read_rsa_2048.sh
./tpm_nv_write_aes_256.sh
./tpm_nv_read_aes_256.sh
./tpm_err_aes_nvwrite.sh
./tpm_err_aes_nvread.sh
./tpm_nv_passphrase_read.sh
./tpm_nv_passphrase_write.sh
```

### Notes:
Replace placeholders like `hash of file` and `data` with actual values before running the scripts.

Ensure that you have the necessary `TPM tools` and permissions to run these scripts.
