<!-- File: README.md
     Author: Daniel Selvan D., Jasmin Infotech
     Author: RJ Fendricks, BG Networks
-->

<p align="center">
    <img src="docs/assets/BGN_logo.png" alt="BGN_logo" />
</p>

# meta-essa


[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/bgn-essa/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption and/or authentication. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

To provide strong cybersecurity without compromising performance or functionality, this architecture leverages:

- In-silicon cryptographic accelerators and secure memory
- Linux security features

The ESSA is Linux based and when used in conjunction with the SAT will support:

- Hardware root of trust extended to the rootfs and software application layer Configuration of Linux Device Mapper (DM) cryptographic functions.
- Use of AES-XTS and HMAC-SHA256 cryptographic algorithms.
- Root of trust extended to Linux userspace.


## Meta-essa TPM changes includes:
- meta-tpm layer -> has tpm stack 
- u-boot changes for spi, tpm configurations for tpm infineon slb970  hardware
- kernel changes for spi, tpm configurations for tpm infineon slb970  hardware
				
Meta-tpm layer contains:
- tpm , tpm2 stack
- version:5.5 \
 git_link: https://gitlab.com/akuster/meta-security/-/blob/mickledore/meta-tpm/conf/layer.conf?ref_type=heads
- meta-tpm-cfg spi configuration 

## Build Steps:
Modify bblayers.conf in build directory to include this layer while building.
Ex: in bblayers.conf add this line at last.

 BBLAYERS += " ${BSPDIR}/sources/meta-essa" \
 BBLAYERS += " ${BSPDIR}/sources/meta-essa/meta-tpm"

To Build tpm or tpm2 image:
- bitbake security-tpm-image
- bitbake security-tpm2-image

### To test: 
Flash this image from output directory -> security-tpm2-image-imx8mmevk.rootfs.wic
Note: U-boot was not part of wic image.

Note:
         We were observing below error while building security-tpm-image. \
ERROR: packagegroup-security-tpm2-1.0-r0 do_package_write_deb: An allarch packagegroup shouldn't depend on packages which are dynamically renamed (libtss2-tcti-device to libtss2-tcti-device0)
ERROR: packagegroup-security-tpm2-1.0-r0 do_package_write_deb: An allarch packagegroup shouldn't depend on packages which are dynamically renamed (libtss2-tcti-mssim to libtss2-tcti-mssim0)
It doesnt affect creating images.

## Supported boards

The following boards are supported natively by this layer:

- NXP i.<d/>MX 8M Mini EVK (imx8mmevk) - [8MMINILPD4-EVK](https://www.nxp.com/part/8MMINILPD4-EVK#/)
- NXP's i.<d/>MX 6 SoloX SABRE (imx6sxsabresd) - [i.MX 6 SoloX SABRE](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/sabre-board-for-smart-devices-based-on-the-i-mx-6solox-applications-processors:RD-IMX6SX-SABRE)
- NXP's i.<d/>MX 6 UltraLite Evaluation Kit (imx6ulevk) - [i.MX 6 UltraLite EVK](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/i-mx6ultralite-evaluation-kit:MCIMX6UL-EVK)

## Quick Start Guide

See the [Quick Start Guide](docs/Quick_Start_Guide.md) for instructions of building core image and for a quick demo of **DM-Crypt with CAAM's black key**.

## Detailed Guide

To know more about the [BG Networks ESSA](https://bgnet.works/bgn-essa) and its potential capabilities, [contact BG Networks](https://bgnet.works/contact-us).

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-essa-mx6ul/pulls).

