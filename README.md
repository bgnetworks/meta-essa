<!-- File: README.md
     Author: Daniel Selvan D., Jasmin Infotech
-->

# meta-essa-mx8mm

This repository is based on [i.MX Linux Yocto Project BSP](https://source.codeaurora.org/external/imx/imx-manifest/tree/?h=imx-linux-hardknott) (_5.10.72-2.2.0.xml release_) on NXP's [Evaluation Kit for the i.MX 8M Mini Applications Processor](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/evaluation-kit-for-the-i-mx-8m-mini-applications-processor:8MMINILPD4-EVK).

## Supported board

**NOTE**: This is release is not a production release.

The following board is the only board tested in this release.

- NXP i.<d/>MX 8M Mini EVK (imx8mmevk) - [8MMINILPD4-EVK](https://www.nxp.com/part/8MMINILPD4-EVK#/)

## Quick Start Guide

See the i.<d/>MX Yocto Project User's Guide for instructions on installing repo.

1. Install the i.<d/>MX Linux BSP & ESSA repo

```bash
repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.72-2.2.0.xml

# Can be downloaded from public repositories only
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/bgnetworks/meta-mender-imx8mm/hardknott/meta-essa-mx8mm/scripts/imx-5.10.72-2.2.0_essa.xml
repo init -m imx-5.10.72-2.2.0_essa.xml
```

2. Download the Yocto Project Layers:

```bash
repo sync -j$(nproc)
```

If you encounter errors on repo init, remove the `.repo` directory and try `repo init` again.

3. Run i.<d/>MX Linux Yocto Project Setup:

```bash
$ MACHINE=imx8mmevk DISTRO=fsl-imx-xwayland source mx8mm-setup-essa.sh -b <build_folder>
```

where

- `<build_folder>` specifies the build folder name

After this your system will be configured to start a Yocto Project build.

## Build images

#### Building Wayland

```bash
MACHINE=imx8mmevk DISTRO=fsl-imx-xwayland source mx8mm-setup-essa.sh -b build-wayland
bitbake core-image-base
```

**core-image-base**: "A console-only image that fully supports the target device hardware."

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please send the patches as bellow:

- meta-mender-imx: files and configuration for mender integration with [i.MX 8mm EVK](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/evaluation-kit-for-the-i-mx-8m-mini-applications-processor:8MMINILPD4-EVK)
  Path: sources/meta-essa-mx8mm
  GIT: https://github.com/mendersoftware/meta-mender-community.git

## Maintainer

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)
- Sivaprasad SV - <sivaprasad.sv@jasmin-infotech.com> - [svsprasad96](https://github.com/svsprasad96)

Always include the maintainers when suggesting code changes to this layer.

## Limitation

`repo sync` won't work on private repositories and hence the above commands can only be executed successfully, if this repo's visibility changes to **Public**
