# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

SUMMARY = "tpm test scripts"
LICENSE = "CLOSED"

SRC_URI = " \
    file://tpm_policy_creation.sh \
    file://tpm_error_aes_nvread.sh \
    file://tpm_error_aes_nvwrite.sh \
    file://tpm_nv_read_aes_256.sh \
    file://tpm_nv_write_aes_256.sh \
    file://tpm_nv_read_rsa_2048.sh \
    file://tpm_nv_write_rsa_2048.sh \
    file://tpm_nv_passphrase_read.sh \
    file://tpm_nv_passphrase_write.sh \
"

RDEPENDS:${PN} += "bash"

do_install() {
    # Installing the test scripts in /etc/tpm/user_examples
    install -d ${D}/etc/tpm/user_examples
      
    install -m 0755 ${WORKDIR}/tpm_policy_creation.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_error_aes_nvread.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_error_aes_nvwrite.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_read_aes_256.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_write_aes_256.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_read_rsa_2048.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_write_rsa_2048.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_passphrase_read.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_passphrase_write.sh ${D}/etc/tpm/user_examples
}

FILES:${PN} += " \
    /etc/tpm/user_examples/tpm_policy_creation.sh \
    /etc/tpm/user_examples/tpm_error_aes_nvread.sh \
    /etc/tpm/user_examples/tpm_error_aes_nvwrite.sh \
    /etc/tpm/user_examples/tpm_nv_read_aes_256.sh \
    /etc/tpm/user_examples/tpm_nv_write_aes_256.sh \
    /etc/tpm/user_examples/tpm_nv_read_rsa_2048.sh \
    /etc/tpm/user_examples/tpm_nv_write_rsa_2048.sh \
    /etc/tpm/user_examples/tpm_nv_passphrase_read.sh \
    /etc/tpm/user_examples/tpm_nv_passphrase_write.sh \
"
