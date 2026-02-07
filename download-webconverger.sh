#!/bin/bash

# Download Webconverger using curl

echo "📥 Downloading Webconverger ISO..."
curl -L -o webconverger.iso "https://dl.webconverger.com/latest.iso"

if [ $? -eq 0 ]; then
    echo "✅ Download complete: webconverger.iso"
    echo ""
    ls -lh webconverger.iso
    echo ""
    echo "Flash to USB with:"
    echo "  sudo dd if=webconverger.iso of=/dev/sdX bs=4M status=progress && sync"
else
    echo "❌ Download failed"
    exit 1
fi
