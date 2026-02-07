#!/bin/bash

# Webconverger Pre-Configuration Script
# Downloads Webconverger and adds custom boot parameters

set -e

echo "Downloading Webconverger ISO..."
wget -O webconverger.iso "https://dl.webconverger.com/latest.iso"

echo "Creating custom configuration..."

# Extract ISO
mkdir -p webconverger-extract webconverger-custom
sudo mount -o loop webconverger.iso webconverger-extract
sudo cp -r webconverger-extract/* webconverger-custom/
sudo umount webconverger-extract

# Create custom boot configuration with your settings
cat > webconverger-custom/isolinux/isolinux.cfg << 'EOF'
DEFAULT kiosk
PROMPT 0
TIMEOUT 0

LABEL kiosk
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd.img boot=live quiet splash homepage=https://www.google.com.br bookmarks=https://www.globo.com.br|Globo,https://www.uol.com.br|UOL,https://www.gazetadopovo.com.br|Gazeta%20do%20Povo,https://www.youtube.com|YouTube,https://www.espn.com.br|ESPN%20Brasil,https://www.gazetaesportiva.com.br|Gazeta%20Esportiva noblank kioskresetstation=10 chrome-opts=--force-safesearch dns1=185.228.168.168 dns2=185.228.169.168
EOF

# Create new ISO with custom settings
echo "Creating custom ISO..."
sudo xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "KIOSK_WEBCONVERGER" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -output webconverger-custom.iso \
    webconverger-custom/

# Cleanup
sudo rm -rf webconverger-extract webconverger-custom

echo ""
echo "✅ Custom ISO created: webconverger-custom.iso"
echo ""
echo "Flash to USB:"
echo "  sudo dd if=webconverger-custom.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo "Pre-configured with:"
echo "  - Your Brazilian bookmarks"
echo "  - CleanBrowsing Family DNS"
echo "  - SafeSearch enforcement"
echo "  - Auto-reset every 10 minutes"
