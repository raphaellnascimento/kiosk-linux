#!/bin/bash

# BUILD KIOSK ISO ON XUBUNTU - Complete Script
# Copy this entire file to your Xubuntu machine and run it

set -e

echo "=========================================="
echo "  Kiosk Linux ISO Builder for Xubuntu"
echo "=========================================="
echo ""

# Step 1: Install dependencies
echo "Step 1: Installing build dependencies..."
sudo apt-get update
sudo apt-get install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    git

echo ""
echo "✅ Dependencies installed!"
echo ""

# Step 2: Clone the project
echo "Step 2: Downloading kiosk project from GitHub..."
cd ~
rm -rf kiosk-linux
git clone https://github.com/raphaellnascimento/kiosk-linux.git
cd kiosk-linux

echo ""
echo "✅ Project downloaded!"
echo ""

# Step 3: Build the ISO
echo "Step 3: Building ISO (this takes 15-20 minutes)..."
echo ""
echo "⏳ Starting build..."
echo ""

sudo ./build-iso.sh

echo ""
echo "=========================================="
echo "  ✅ BUILD COMPLETE!"
echo "=========================================="
echo ""
echo "ISO created: ~/kiosk-linux/kiosk-linux.iso"
echo ""
ls -lh ~/kiosk-linux/kiosk-linux.iso
echo ""
echo "Next steps:"
echo ""
echo "1. Insert USB drive"
echo ""
echo "2. Find USB drive:"
echo "   lsblk"
echo ""
echo "3. Flash to USB (replace sdX with your drive!):"
echo "   sudo dd if=~/kiosk-linux/kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync"
echo ""
echo "4. Boot from USB and enjoy your kiosk!"
echo ""
echo "🎉 Done!"
