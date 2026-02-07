#!/bin/bash

# Quick Kiosk ISO Download for Xubuntu
# Run this on your Xubuntu machine

echo "================================================"
echo "  Downloading Webconverger Kiosk ISO"
echo "================================================"
echo ""

# Download Webconverger
echo "📥 Downloading... (this takes 5-10 minutes)"
wget https://dl.webconverger.com/latest.iso -O webconverger-kiosk.iso

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "  ✅ SUCCESS! ISO Downloaded"
    echo "================================================"
    echo ""
    ls -lh webconverger-kiosk.iso
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Find your USB drive:"
    echo "   lsblk"
    echo ""
    echo "2. Flash to USB (replace sdX with your drive!):"
    echo "   sudo dd if=webconverger-kiosk.iso of=/dev/sdX bs=4M status=progress && sync"
    echo ""
    echo "3. Boot from USB"
    echo ""
    echo "4. Add bookmarks at first boot (press TAB at boot menu):"
    echo '   bookmarks="https://www.globo.com.br|Globo,https://www.uol.com.br|UOL,https://www.gazetadopovo.com.br|Gazeta,https://www.youtube.com|YouTube,https://www.espn.com.br|ESPN,https://www.gazetaesportiva.com.br|Gazeta Esportiva" dns1=185.228.168.168'
    echo ""
    echo "That's it! 🎉"
else
    echo ""
    echo "❌ Download failed!"
    echo ""
    echo "Try downloading via browser:"
    echo "https://webconverger.com/download/"
    exit 1
fi
