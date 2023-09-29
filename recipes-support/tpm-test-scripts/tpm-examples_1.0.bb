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
    file://tpm_err_aes_nvread.sh \
    file://tpm_err_aes_nvwrite.sh \
    file://tpm_pcr_state_nv_read.sh \
    file://tpm_pcr_state_nv_write.sh \
    file://tpm_nv_read_rsa_2048.sh \
    file://tpm_nv_write_rsa_2048.sh \
    file://tpm_rsa_passphrase_read_in_nv.sh \
    file://tpm_rsa_passphrase_write_in_nv.sh \
"

RDEPENDS:${PN} += "bash"

do_install() {
    # Installing the test scripts in /etc/tpm/user_examples
    install -d ${D}/etc/tpm/user_examples
      
    install -m 0755 ${WORKDIR}/tpm_err_aes_nvread.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_err_aes_nvwrite.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_pcr_state_nv_read.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_pcr_state_nv_write.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_read_rsa_2048.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_nv_write_rsa_2048.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_rsa_passphrase_read_in_nv.sh ${D}/etc/tpm/user_examples
    install -m 0755 ${WORKDIR}/tpm_rsa_passphrase_write_in_nv.sh ${D}/etc/tpm/user_examples
}

FILES:${PN} += " \
    /etc/tpm/user_examples/tpm_err_aes_nvread.sh \
    /etc/tpm/user_examples/tpm_err_aes_nvwrite.sh \
    /etc/tpm/user_examples/tpm_pcr_state_nv_read.sh \
    /etc/tpm/user_examples/tpm_pcr_state_nv_write.sh \
    /etc/tpm/user_examples/tpm_nv_read_rsa_2048.sh \
    /etc/tpm/user_examples/tpm_nv_write_rsa_2048.sh \
    /etc/tpm/user_examples/tpm_rsa_passphrase_read_in_nv.sh \
    /etc/tpm/user_examples/tpm_rsa_passphrase_write_in_nv.sh \
"
