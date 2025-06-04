# automatic-download-isos-in-usb

A Bash script for downloading popular ISO images directly to a selected USB flash drive. Ideal for sysadmins, DevOps engineers, and IT support specialists who frequently work with installation, recovery, and diagnostics tools.

## Who is this for?

This script is useful for:

- **System administrators** – maintain a bootable toolkit with essential Linux distros and recovery tools.
- **DevOps engineers** – quickly provision USBs with specific environments.
- **IT support technicians** – carry ready-to-use rescue, partitioning, and memory testing tools.
- **Anyone using Ventoy** – manage ISOs easily on a multiboot USB.

## Features

- Detects connected USB drives and allows selection
- Offers multiple ISO categories:
  - Linux Distributions
  - Live & Rescue Tools
  - Security & Pentesting
- Lets you choose specific ISOs from each category
- Avoids downloading duplicates
- Alerts you if a download fails (e.g., due to network issues)

## Available ISO categories

**Linux Distributions**
- Ubuntu Desktop 24.04.2
- Ubuntu Server 24.04.2
- Debian 12.11 netinst
- Arch Linux
- AlmaLinux 9.4
- Fedora Workstation 40
- openSUSE Leap 15.5

**Live & Rescue Tools**
- Rescuezilla 2.6
- SystemRescue
- GParted Live
- Hiren’s BootCD PE
- Clonezilla
- Memtest86+

**Security & Pentesting**
- Kali Linux
- Parrot OS Home
- Tails
- BackBox Linux

## How to use

1. Insert and mount a USB flash drive if you want to save ISOs there
2. Run the script and choose a USB drive or local folder when prompted:

```bash
chmod +x iso-downloader.sh
./iso-downloader.sh
```
