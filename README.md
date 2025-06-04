# automatic-download-isos-in-usb

Этот скрипт на Bash автоматически скачивает нужные ISO-образы в выбранную USB-флешку.

## 🔧 Возможности

- Показывает список всех подключённых USB-накопителей
- Позволяет выбрать, **куда скачивать ISO**
- Даёт список ISO-образов для выбора
- Скачивает только выбранные образы
- Проверяет, были ли образы уже загружены

## 📦 Поддерживаемые ISO

- Ubuntu Desktop 24.04
- Ubuntu Server 24.04
- Debian 12.5 netinst
- Arch Linux
- AlmaLinux 9.4
- Rescuezilla
- SystemRescue
- GParted Live
- Hiren's BootCD PE
- Kali Linux

## 🚀 Быстрый старт

1. Подключи USB-флешку и смонтируй её (обычно это `/run/media/<user>/<название>`)
2. Запусти скрипт:

```bash
chmod +x iso-downloader.sh
./iso-downloader.sh
```
