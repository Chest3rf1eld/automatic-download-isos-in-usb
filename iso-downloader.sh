#!/bin/bash

echo "🔍 Ищем подключённые USB-накопители..."

usb_devices=($(ls /dev/disk/by-id/usb-* 2>/dev/null | grep -v "part"))

if [ ${#usb_devices[@]} -eq 0 ]; then
  echo "❌ USB-накопители не найдены."
  exit 1
fi

echo "📋 Найдены устройства:"
i=1
for dev in "${usb_devices[@]}"; do
  real_dev=$(readlink -f "$dev")
  mountpoint=$(lsblk -no MOUNTPOINT "$real_dev" | grep -v '^$' | head -n1)
  echo "[$i] $real_dev ($mountpoint)"
  mountpoints[$i]="$mountpoint"
  devs[$i]="$real_dev"
  ((i++))
done

read -rp "👉 Введите номер флешки для загрузки ISO: " choice
download_dir="${mountpoints[$choice]}"

if [ -z "$download_dir" ]; then
  echo "❌ Не удалось определить точку монтирования. Возможно, флешка не смонтирована."
  exit 1
fi

cd "$download_dir" || { echo "❌ Не удалось перейти в $download_dir"; exit 1; }
echo "📁 Скачивание в: $download_dir"

# Список ISO-файлов (без Windows)
declare -A iso_links=(
  ["Ubuntu Desktop 24.04"]="https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso"
  ["Ubuntu Server 24.04"]="https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso"
  ["Debian 12.5 netinst"]="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
  ["Arch Linux"]="https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso"
  ["AlmaLinux 9.4"]="https://repo.almalinux.org/almalinux/9.4/isos/x86_64/AlmaLinux-9.4-x86_64-dvd.iso"
  ["Rescuezilla"]="https://github.com/rescuezilla/rescuezilla/releases/download/2.5.4/rescuezilla-2.5.4-64bit.iso"
  ["SystemRescue"]="https://www.system-rescue.org/download/systemrescue-11.01-amd64.iso"
  ["GParted Live"]="https://downloads.sourceforge.net/project/gparted/gparted-live/stable-1.6.0-3/gparted-live-1.6.0-3-amd64.iso"
  ["Hiren's BootCD PE"]="https://www.hirensbootcd.org/files/HBCD_PE_x64.iso"
  ["Kali Linux"]="https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-installer-amd64.iso"
)

echo ""
echo "🧾 Доступные ISO образы:"
i=1
for name in "${!iso_links[@]}"; do
  printf "[%2d] %s\n" $i "$name"
  iso_names[$i]="$name"
  ((i++))
done

echo ""
read -rp "👉 Введите номера через пробел (например: 1 3 5): " -a selected

for num in "${selected[@]}"; do
  name="${iso_names[$num]}"
  url="${iso_links[$name]}"
  filename=$(basename "$url")

  if [ -f "$filename" ]; then
    echo "✅ Уже есть: $filename"
  else
    echo "⬇️ Скачиваем $name..."
    curl -LO "$url"
  fi
done

echo "🎉 Готово! Все выбранные ISO скачаны в $download_dir"
