#!/bin/bash

# Make Webconverger bookmarks permanent on USB
# Run this AFTER flashing the ISO to USB

set -e

if [ -z "$1" ]; then
    echo "Usage: sudo ./MAKE-PERMANENT.sh /dev/sdX"
    echo "Example: sudo ./MAKE-PERMANENT.sh /dev/sdb"
    echo ""
    echo "Run 'lsblk' to find your USB drive"
    exit 1
fi

USB_DEVICE=$1

echo "Making bookmarks permanent on $USB_DEVICE..."
echo ""

# Mount the USB
mkdir -p /tmp/usb-mount
sudo mount ${USB_DEVICE}1 /tmp/usb-mount 2>/dev/null || sudo mount ${USB_DEVICE} /tmp/usb-mount

# Edit boot configuration
echo "Updating boot configuration..."

# Backup original
sudo cp /tmp/usb-mount/boot/grub/grub.cfg /tmp/usb-mount/boot/grub/grub.cfg.backup 2>/dev/null || true
sudo cp /tmp/usb-mount/isolinux/isolinux.cfg /tmp/usb-mount/isolinux/isolinux.cfg.backup 2>/dev/null || true

# Add permanent boot parameters
BOOT_PARAMS='homepage=https://www.google.com.br bookmarks="https://www.globo.com.br|Globo,https://www.uol.com.br|UOL,https://www.gazetadopovo.com.br|Gazeta do Povo,https://www.youtube.com|YouTube,https://www.espn.com.br|ESPN Brasil,https://www.gazetaesportiva.com.br|Gazeta Esportiva" noblank kioskresetstation=0 dns1=185.228.168.168 dns2=185.228.169.168'

# Try to update isolinux config
if [ -f /tmp/usb-mount/isolinux/isolinux.cfg ]; then
    sudo sed -i "s|append boot=live|append boot=live $BOOT_PARAMS|g" /tmp/usb-mount/isolinux/isolinux.cfg
    echo "✅ Updated isolinux.cfg"
fi

# Try to update grub config
if [ -f /tmp/usb-mount/boot/grub/grub.cfg ]; then
    sudo sed -i "s|boot=live|boot=live $BOOT_PARAMS|g" /tmp/usb-mount/boot/grub/grub.cfg
    echo "✅ Updated grub.cfg"
fi

# Unmount
sudo umount /tmp/usb-mount
rmdir /tmp/usb-mount

echo ""
echo "✅ Configuration saved permanently!"
echo ""
echo "Your bookmarks will persist after every reboot."
echo "The kiosk will NOT reset to blank state (kioskresetstation=0)."
echo ""
echo "To restore original behavior, restore the .backup files."
