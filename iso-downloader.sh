#!/bin/bash

# 1. Выбор места скачивания
echo "📂 Where do you want to download ISOs?"
echo "[1] USB flash drive"
echo "[2] Local folder"
read -rp "👉 Enter option number: " dest_option

if [ "$dest_option" = "1" ]; then
  echo "🔍 Searching for connected USB drives..."
  usb_devices=($(ls /dev/disk/by-id/usb-* 2>/dev/null | grep -v "part"))

  if [ ${#usb_devices[@]} -eq 0 ]; then
    echo "❌ No USB drives found."
    exit 1
  fi

  echo "📋 Available USB drives:"
  i=1
  for dev in "${usb_devices[@]}"; do
    real_dev=$(readlink -f "$dev")
    mountpoint=$(lsblk -no MOUNTPOINT "$real_dev" | grep -v '^$' | head -n1)
    echo "[$i] $real_dev ($mountpoint)"
    mountpoints[$i]="$mountpoint"
    ((i++))
  done

  read -rp "👉 Enter number of USB drive to use: " choice
  download_dir="${mountpoints[$choice]}"

  if [ -z "$download_dir" ]; then
    echo "❌ Could not detect mount point. Is the drive mounted?"
    exit 1
  fi

  read -rp "👉 Enter download folder (default: $download_dir): " custom_dir
  if [ -n "$custom_dir" ]; then
    download_dir="$custom_dir"
  fi
elif [ "$dest_option" = "2" ]; then
  read -rp "👉 Enter local download folder: " download_dir
else
  echo "❌ Invalid option."
  exit 1
fi

mkdir -p "$download_dir" || {
  echo "❌ Failed to create $download_dir"
  exit 1
}

cd "$download_dir" || { echo "❌ Failed to cd into $download_dir"; exit 1; }
echo "📁 Downloading to: $download_dir"

# 3. Выбор категории
declare -A categories=(
  [1]="Linux Distros"
  [2]="Live & Rescue Tools"
  [3]="Security & Pentesting"
)

echo ""
echo "🗂️ Available categories:"
for key in "${!categories[@]}"; do
  echo "[$key] ${categories[$key]}"
done

read -rp "👉 Choose category number: " cat_choice
category="${categories[$cat_choice]}"

# 4. ISO-файлы по категориям
declare -A iso_links

if [ "$category" == "Linux Distros" ]; then
  declare -A iso_links=(
  ["Ubuntu Desktop 24.04.2"]="https://releases.ubuntu.com/24.04/ubuntu-24.04.2-desktop-amd64.iso"
  ["Ubuntu Server 24.04.2"]="https://releases.ubuntu.com/24.04/ubuntu-24.04.2-live-server-amd64.iso"
  ["Debian 12.11 netinst"]="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
    ["Arch Linux"]="https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso"
    ["AlmaLinux 9.4"]="https://repo.almalinux.org/almalinux/9.4/isos/x86_64/AlmaLinux-9.4-x86_64-dvd.iso"
    ["Fedora Workstation"]="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-40-1.14.iso"
    ["OpenSUSE Leap 15.5"]="https://download.opensuse.org/distribution/leap/15.5/iso/openSUSE-Leap-15.5-DVD-x86_64.iso"
  )
elif [ "$category" == "Live & Rescue Tools" ]; then
  declare -A iso_links=(
  ["Rescuezilla 2.6"]="https://github.com/rescuezilla/rescuezilla/releases/download/2.6/rescuezilla-2.6-64bit.jammy.iso"
    ["SystemRescue"]="https://www.system-rescue.org/download/systemrescue-11.01-amd64.iso"
    ["GParted Live"]="https://downloads.sourceforge.net/project/gparted/gparted-live/stable-1.6.0-3/gparted-live-1.6.0-3-amd64.iso"
    ["Hiren's BootCD PE"]="https://www.hirensbootcd.org/files/HBCD_PE_x64.iso"
    ["Clonezilla Live"]="https://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.1.2-9/clonezilla-live-3.1.2-9-amd64.iso"
    ["Memtest86+"]="https://www.memtest.org/download/v6.20/memtest86+-6.20.iso.zip"
  )
elif [ "$category" == "Security & Pentesting" ]; then
  declare -A iso_links=(
    ["Kali Linux"]="https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-installer-amd64.iso"
    ["Parrot OS Home"]="https://download.parrot.sh/parrot/iso/5.3/Parrot-home-5.3_amd64.iso"
    ["Tails"]="https://mirror.cyberbits.eu/tails/stable/tails-amd64-5.23/tails-amd64-5.23.iso"
    ["BackBox Linux"]="https://mirror.backbox.org/backbox/backbox-8-desktop-amd64.iso"
  )
else
  echo "❌ Unknown category."
  exit 1
fi

# 5. Выбор ISO-файлов
echo ""
echo "📦 Available ISOs in '$category':"
i=1
for name in "${!iso_links[@]}"; do
  printf "[%2d] %s\n" $i "$name"
  iso_names[$i]="$name"
  ((i++))
done

echo ""
read -rp "👉 Enter numbers to download (e.g. 1 3 5): " -a selected

for num in "${selected[@]}"; do
  name="${iso_names[$num]}"
  url="${iso_links[$name]}"
  filename=$(basename "$url")

  if [ -f "$filename" ]; then
    echo "✅ Already exists: $filename"
  else
    echo "⬇️ Downloading $name..."
    curl -LO "$url"
  fi
done

echo "🎉 Done! Selected ISOs downloaded to $download_dir"
