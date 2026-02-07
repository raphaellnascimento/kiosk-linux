#!/bin/bash

# Simple Webconverger Setup - No ISO modification needed
# Just creates boot parameters file

set -e

echo "=========================================="
echo "Webconverger Kiosk - Simple Setup"
echo "=========================================="
echo ""

# Download Webconverger
if [ ! -f "webconverger.iso" ]; then
    echo "📥 Downloading Webconverger ISO (~300MB)..."
    wget -O webconverger.iso "https://dl.webconverger.com/latest.iso" || {
        echo "❌ Download failed. Trying mirror..."
        wget -O webconverger.iso "https://build.webconverger.com/latest.iso"
    }
else
    echo "✅ webconverger.iso already exists, skipping download"
fi

echo ""
echo "=========================================="
echo "✅ ISO Ready: webconverger.iso"
echo "=========================================="
echo ""
echo "📋 Configuration for First Boot:"
echo ""
echo "When you boot Webconverger for the first time, press TAB"
echo "at the boot screen and add these parameters:"
echo ""
echo "homepage=https://www.google.com.br bookmarks=\"https://www.globo.com.br|Globo,https://www.uol.com.br|UOL,https://www.gazetadopovo.com.br|Gazeta do Povo,https://www.youtube.com|YouTube,https://www.espn.com.br|ESPN Brasil,https://www.gazetaesportiva.com.br|Gazeta Esportiva\" noblank kioskresetstation=600 dns1=185.228.168.168 dns2=185.228.169.168"
echo ""
echo "Or just use it as-is and configure via their web panel!"
echo ""
echo "=========================================="
echo "📀 Flash to USB:"
echo "=========================================="
echo ""
echo "sudo dd if=webconverger.iso of=/dev/sdX bs=4M status=progress && sync"
echo ""
echo "(Replace /dev/sdX with your USB drive from 'lsblk')"
echo ""

# Calculate size
SIZE=$(du -h webconverger.iso | cut -f1)
echo "📦 ISO Size: $SIZE"
echo ""
echo "✅ Done! Flash to USB and boot!"
