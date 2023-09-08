<!-- File: README.md
     Author: saravanan.J, Jasmin Infotech
-->

<p align="center">
    <img src="docs/assets/BGN_logo.png" alt="BGN_logo" />
</p>

# meta-essa


Yocto Layer for Creating Customized InitramFS for RootFS Encryption/Decryption:

This layer provides information about customized Yocto layer for initramfs to encrypt & decrypt rootFS. Layer has support to boot initramfs at uboot.
Included Packages

    - Hardware root of trust extended to the initramfs and software application layer Configuration of Linux Device Mapper (DM) cryptographic functions.

    - Included caam-keygen utility for key generation, dm-setup for CBC-AES encryption.

Modify the Recipe Append Files

    Modify this bbappend file (recipes-core/images/core-image-minimal-initramfs.bbappend) to add/remove packages from initramfs.


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

**Note:** Initramfs is tested with iMX6SoloX SABRE

## Build and test
```
MACHINE=imx6sxsabresd DISTRO=fsl-imx-xwayland source setup-essa.sh -b <BUILD_DIR>
```

Run the following command to build live initramfs image

```
bitbake core-image-minimal-initramfs-bgn
```

Run the following command to build mfg initramfs image
```
bitbake core-image-minimal-mfg-initramfs-bgn
```

Note:

To test live initramfs image:

Prepare the SD, by copying the wic image.
Copy the u-boot into QSPI memory.
After the build, copy the `core-image-minimal-live-initramfs-imx6sxsabresd.cpio.gz` file to boot partition (FAT) in SD card.
Stop at u-boot console & give below command.
"run liveinitramfskernelboot"

To test mfg initramfs image:

Prepare the SD, by copying the wic image.
Copy the u-boot into QSPI memory.
After the build, copy the `core-image-minimal-mfg-initramfs-imx6sxsabresd.cpio.gz` file to boot partition (FAT) in SD card.
Stop at u-boot console & give below command.
"run mfginitramfskernelboot"
