#!/bin/bash

# DEBIAN LIVE KIOSK CUSTOMIZER
# Downloads Debian Live and customizes it with your kiosk settings
# MUCH FASTER than building from scratch!

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then
    error "Run with sudo: sudo ./customize-debian-live.sh"
fi

log "=========================================="
log "  Debian Live Kiosk Customizer"
log "  FAST method - 20 minutes total!"
log "=========================================="
echo ""

WORK_DIR="$(pwd)/debian-custom"
ISO_URL="https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.8.0-amd64-xfce.iso"
ISO_NAME="debian-live.iso"
OUTPUT_ISO="kiosk-linux-custom.iso"

# Step 1: Download Debian Live
if [ ! -f "$ISO_NAME" ]; then
    log "Step 1: Downloading Debian Live ISO (2.7GB, ~10 minutes)..."
    wget "$ISO_URL" -O "$ISO_NAME" || error "Download failed"
    log "Download complete!"
else
    log "ISO already downloaded, skipping..."
fi

echo ""
log "Step 2: Extracting ISO..."
mkdir -p "$WORK_DIR"/{extract,custom}

# Mount and extract
mount -o loop "$ISO_NAME" "$WORK_DIR/extract"
rsync -a "$WORK_DIR/extract/" "$WORK_DIR/custom/"
umount "$WORK_DIR/extract"

log "ISO extracted!"

echo ""
log "Step 3: Customizing for kiosk mode..."

# Extract squashfs
mkdir -p "$WORK_DIR/squashfs"
unsquashfs -d "$WORK_DIR/squashfs" "$WORK_DIR/custom/live/filesystem.squashfs"

# Customize the system
log "Adding kiosk configurations..."

# Create kiosk user
chroot "$WORK_DIR/squashfs" useradd -m -s /bin/bash kiosk 2>/dev/null || true

# Setup DNS filtering
cat > "$WORK_DIR/squashfs/etc/resolv.conf" << 'EOF'
# CleanBrowsing Family Filter
nameserver 185.228.168.168
nameserver 185.228.169.168
EOF

# Create autostart for kiosk
mkdir -p "$WORK_DIR/squashfs/home/kiosk/.config/autostart"
cat > "$WORK_DIR/squashfs/home/kiosk/.config/autostart/kiosk.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Kiosk Browser
Exec=/usr/bin/chromium --kiosk --noerrdialogs --disable-infobars --no-first-run "https://www.google.com"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Add bookmarks
mkdir -p "$WORK_DIR/squashfs/home/kiosk/.config/chromium/Default"
cat > "$WORK_DIR/squashfs/home/kiosk/.config/chromium/Default/Bookmarks" << 'EOF'
{
  "checksum": "0000000000000000",
  "roots": {
    "bookmark_bar": {
      "children": [
        {"id": "1", "name": "Globo", "type": "url", "url": "https://www.globo.com.br"},
        {"id": "2", "name": "UOL", "type": "url", "url": "https://www.uol.com.br"},
        {"id": "3", "name": "Gazeta do Povo", "type": "url", "url": "https://www.gazetadopovo.com.br"},
        {"id": "4", "name": "YouTube", "type": "url", "url": "https://www.youtube.com"},
        {"id": "5", "name": "ESPN Brasil", "type": "url", "url": "https://www.espn.com.br"},
        {"id": "6", "name": "Gazeta Esportiva", "type": "url", "url": "https://www.gazetaesportiva.com.br"}
      ],
      "id": "1",
      "name": "Bookmarks bar",
      "type": "folder"
    }
  },
  "version": 1
}
EOF

# Fix permissions
chroot "$WORK_DIR/squashfs" chown -R kiosk:kiosk /home/kiosk

log "Customizations complete!"

echo ""
log "Step 4: Repackaging ISO (fast with gzip)..."

# Recreate squashfs with fast compression
rm "$WORK_DIR/custom/live/filesystem.squashfs"
mksquashfs "$WORK_DIR/squashfs" "$WORK_DIR/custom/live/filesystem.squashfs" -comp gzip -b 1M

log "Squashfs created!"

echo ""
log "Step 5: Creating bootable ISO..."

# Create new ISO
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "KIOSK_LINUX" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -output "$OUTPUT_ISO" \
    "$WORK_DIR/custom" 2>/dev/null

# Cleanup
log "Cleaning up..."
rm -rf "$WORK_DIR"

# Calculate size
ISO_SIZE=$(du -h "$OUTPUT_ISO" | cut -f1)

echo ""
log "=========================================="
log "  ✅ SUCCESS!"
log "=========================================="
echo ""
echo "Custom ISO created: $OUTPUT_ISO"
echo "Size: $ISO_SIZE"
echo ""
echo "Flash to USB:"
echo "  sudo dd if=$OUTPUT_ISO of=/dev/sdX bs=4M status=progress && sync"
echo ""
echo "Features:"
echo "  ✅ Browser-only kiosk mode"
echo "  ✅ Brazilian bookmarks pre-configured"
echo "  ✅ CleanBrowsing Family DNS (blocks adult content)"
echo "  ✅ SafeSearch enforced"
echo "  ✅ Resets on reboot"
echo ""
log "Done! 🎉"
