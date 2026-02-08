#!/bin/bash
set -e

# Kiosk Linux ISO Builder
# Creates a bootable ISO with browser-only kiosk environment

WORK_DIR="$(pwd)/build"
ISO_NAME="kiosk-linux.iso"
ISO_LABEL="KIOSK_LINUX"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "This script must be run as root (use sudo)"
fi

# Check dependencies
log "Checking build dependencies..."
DEPS="debootstrap mksquashfs xorriso"
for dep in $DEPS; do
    if ! command -v $dep &> /dev/null; then
        error "Required dependency '$dep' is not installed"
    fi
done

# Clean previous build
if [ -d "$WORK_DIR" ]; then
    warn "Removing previous build directory..."
    rm -rf "$WORK_DIR"
fi

# Create directory structure
log "Creating build directories..."
mkdir -p "$WORK_DIR"/{chroot,iso/{live,isolinux,boot/grub},scratch}

# Bootstrap minimal Debian system
log "Bootstrapping Debian minimal system (this may take a while)..."
debootstrap --arch=amd64 --variant=minbase bookworm "$WORK_DIR/chroot" http://deb.debian.org/debian/

# Configure the chroot environment
log "Configuring chroot environment..."

# Mount necessary filesystems
mount -t proc none "$WORK_DIR/chroot/proc"
mount -t sysfs none "$WORK_DIR/chroot/sys"
mount -o bind /dev "$WORK_DIR/chroot/dev"
mount -t devpts none "$WORK_DIR/chroot/dev/pts"

# Create cleanup function
cleanup() {
    log "Cleaning up mounts..."
    umount -lf "$WORK_DIR/chroot/proc" 2>/dev/null || true
    umount -lf "$WORK_DIR/chroot/sys" 2>/dev/null || true
    umount -lf "$WORK_DIR/chroot/dev/pts" 2>/dev/null || true
    umount -lf "$WORK_DIR/chroot/dev" 2>/dev/null || true
}
trap cleanup EXIT

# Copy configuration files
log "Copying configuration files..."
cp -r config/* "$WORK_DIR/chroot/tmp/"
cp scripts/setup-chroot.sh "$WORK_DIR/chroot/tmp/"

# Run setup inside chroot
log "Installing packages and configuring system..."
chroot "$WORK_DIR/chroot" /bin/bash /tmp/setup-chroot.sh

# Create squashfs filesystem
log "Creating compressed filesystem (fast compression enabled)..."
mksquashfs "$WORK_DIR/chroot" "$WORK_DIR/iso/live/filesystem.squashfs" \
    -comp gzip -b 1M \
    -e boot

# Copy kernel and initrd
log "Copying kernel and initrd..."
cp "$WORK_DIR/chroot/boot/vmlinuz-"* "$WORK_DIR/iso/live/vmlinuz"
cp "$WORK_DIR/chroot/boot/initrd.img-"* "$WORK_DIR/iso/live/initrd"

# Setup bootloader (isolinux for BIOS)
log "Configuring bootloader..."
cp /usr/lib/ISOLINUX/isolinux.bin "$WORK_DIR/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/*.c32 "$WORK_DIR/iso/isolinux/"

cat > "$WORK_DIR/iso/isolinux/isolinux.cfg" << 'EOF'
DEFAULT kiosk
PROMPT 0
TIMEOUT 0

LABEL kiosk
    KERNEL /live/vmlinuz
    APPEND initrd=/live/initrd boot=live quiet splash components union=overlay
EOF

# Setup GRUB for UEFI
log "Configuring GRUB for UEFI boot..."
cat > "$WORK_DIR/iso/boot/grub/grub.cfg" << 'EOF'
set timeout=0
set default=0

menuentry "Kiosk Linux" {
    linux /live/vmlinuz boot=live quiet splash components union=overlay
    initrd /live/initrd
}
EOF

# Create the ISO
log "Creating bootable ISO..."
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "$ISO_LABEL" \
    -eltorito-boot isolinux/isolinux.bin \
    -eltorito-catalog isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -output "$ISO_NAME" \
    "$WORK_DIR/iso" 2>/dev/null || {
        # Fallback for systems without full UEFI support
        xorriso -as mkisofs \
            -iso-level 3 \
            -full-iso9660-filenames \
            -volid "$ISO_LABEL" \
            -eltorito-boot isolinux/isolinux.bin \
            -eltorito-catalog isolinux/boot.cat \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
            -output "$ISO_NAME" \
            "$WORK_DIR/iso"
    }

# Cleanup
cleanup

# Calculate ISO size and checksum
ISO_SIZE=$(du -h "$ISO_NAME" | cut -f1)
ISO_MD5=$(md5sum "$ISO_NAME" | cut -d' ' -f1)

log "Build complete!"
echo ""
echo "ISO created: $ISO_NAME"
echo "Size: $ISO_SIZE"
echo "MD5: $ISO_MD5"
echo ""
echo "To create a bootable USB drive:"
echo "  sudo dd if=$ISO_NAME of=/dev/sdX bs=4M status=progress"
echo ""
echo "Replace /dev/sdX with your USB drive (check with 'lsblk')"
