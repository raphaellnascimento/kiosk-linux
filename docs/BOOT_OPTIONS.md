# Boot Options - Alternatives to dd Command

If you don't have access to Linux or can't use the `dd` command, here are several alternatives.

## Option 1: Use Graphical USB Creator Tools

### Windows - Rufus (Recommended)

1. Download Rufus: https://rufus.ie/
2. Insert your USB drive
3. Run Rufus
4. Select your USB device
5. Click "SELECT" and choose `kiosk-linux.iso`
6. Partition scheme: `MBR` (for BIOS) or `GPT` (for UEFI)
7. Click "START"
8. Wait for completion

### Windows/Mac/Linux - balenaEtcher

1. Download Etcher: https://etcher.balena.io/
2. Install and run balenaEtcher
3. Click "Flash from file" and select `kiosk-linux.iso`
4. Click "Select target" and choose your USB drive
5. Click "Flash!"
6. Wait for completion

### Mac - Create Bootable USB

```bash
# Find your USB drive
diskutil list

# Unmount the drive (replace diskN with your disk number)
diskutil unmountDisk /dev/diskN

# Write ISO to USB
sudo dd if=kiosk-linux.iso of=/dev/rdiskN bs=1m

# Eject when done
diskutil eject /dev/diskN
```

### Linux - Multiple Methods

**Using Gnome Disks (GUI):**
1. Open "Disks" application
2. Select your USB drive
3. Click the menu (three dots)
4. Select "Restore Disk Image"
5. Choose `kiosk-linux.iso`
6. Click "Start Restoring"

**Using dd (command line):**
```bash
sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync
```

## Option 2: Test in Virtual Machine

Perfect for testing before creating physical media!

### VirtualBox (Free - All Platforms)

1. Download VirtualBox: https://www.virtualbox.org/
2. Install VirtualBox
3. Create new virtual machine:
   - Name: Kiosk Linux
   - Type: Linux
   - Version: Debian (64-bit)
   - Memory: 2048 MB (4096 MB recommended)
   - Create virtual hard disk: 8 GB (optional, not needed for live boot)
4. Settings > Storage:
   - Click "Empty" under Controller: IDE
   - Click disk icon on right
   - Choose "Choose a disk file"
   - Select `kiosk-linux.iso`
5. Settings > System:
   - Enable "Enable EFI"
6. Click "Start"

### VMware Workstation/Player (Free Player Available)

1. Download VMware Player: https://www.vmware.com/products/workstation-player.html
2. Create new virtual machine
3. Select "I will install the operating system later"
4. Guest OS: Linux > Debian 11.x 64-bit
5. Finish creation
6. Edit VM settings > CD/DVD:
   - Select "Use ISO image file"
   - Browse to `kiosk-linux.iso`
7. Power on VM

### QEMU (Command Line - All Platforms)

```bash
# Install QEMU first
# Ubuntu/Debian: sudo apt-get install qemu-system-x86
# Mac: brew install qemu
# Windows: Download from qemu.org

# Run the ISO
qemu-system-x86_64 -cdrom kiosk-linux.iso -m 2048 -enable-kvm
```

### UTM (Mac with Apple Silicon M1/M2)

1. Download UTM: https://mac.getutm.app/
2. Create new virtual machine
3. Select "Emulate"
4. Choose Linux
5. Boot ISO: Browse to `kiosk-linux.iso`
6. Memory: 2048 MB
7. Create and start

## Option 3: Burn to CD/DVD

If you have a CD/DVD burner:

### Windows

1. Right-click `kiosk-linux.iso`
2. Select "Burn disc image"
3. Insert blank CD/DVD
4. Click "Burn"

### Mac

1. Open "Disk Utility"
2. Insert blank CD/DVD
3. Select the disc in the left sidebar
4. Click "Burn" button in toolbar
5. Select `kiosk-linux.iso`
6. Click "Burn"

### Linux

```bash
# Find your CD/DVD drive
lsblk

# Burn ISO (replace /dev/sr0 with your drive)
wodim -v dev=/dev/sr0 kiosk-linux.iso
```

## Option 4: Network Boot (PXE) - Advanced

For booting multiple machines over network:

### Requirements
- TFTP server
- DHCP server with PXE support
- HTTP/NFS server for filesystem

### Basic Setup (Ubuntu Server)

```bash
# Install services
sudo apt-get install tftpd-hpa isc-dhcp-server apache2

# Extract kernel and initrd from ISO
mkdir /tmp/iso
sudo mount -o loop kiosk-linux.iso /tmp/iso
sudo cp /tmp/iso/live/vmlinuz /var/lib/tftpboot/
sudo cp /tmp/iso/live/initrd /var/lib/tftpboot/
sudo cp /tmp/iso/live/filesystem.squashfs /var/www/html/

# Configure DHCP for PXE
# Configure TFTP boot menu
# Configure HTTP to serve filesystem

# This is complex - see full PXE boot guides for details
```

## Option 5: Ventoy - Multi-Boot USB (Recommended for Multiple ISOs)

Ventoy allows you to copy multiple ISOs to USB without reformatting:

1. Download Ventoy: https://www.ventoy.net/
2. Install Ventoy to USB drive (one-time setup)
3. Copy `kiosk-linux.iso` to the USB drive (just copy the file!)
4. Boot from USB and select the ISO

**Advantages:**
- No need to reformat USB each time
- Can have multiple ISOs on one USB
- Just copy ISO files like regular files

## Option 6: Cloud Build Service

If you can't build the ISO locally:

### Use GitHub Actions (Free)

1. Push this code to GitHub
2. Create `.github/workflows/build.yml`:

```yaml
name: Build Kiosk ISO

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-22.04

    steps:
    - uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y debootstrap squashfs-tools xorriso \
          isolinux syslinux-efi grub-pc-bin grub-efi-amd64-bin mtools

    - name: Build ISO
      run: sudo ./build-iso.sh

    - name: Upload ISO
      uses: actions/upload-artifact@v3
      with:
        name: kiosk-linux-iso
        path: kiosk-linux.iso
```

3. Download the built ISO from GitHub Actions artifacts

## Comparison Table

| Method | Ease | Speed | Use Case |
|--------|------|-------|----------|
| Rufus/Etcher | Easy | Fast | Best for single bootable USB |
| Virtual Machine | Easy | Fast | Testing before deployment |
| CD/DVD | Easy | Slow | Permanent read-only media |
| Ventoy | Medium | Fast | Multiple ISOs on one USB |
| PXE Boot | Hard | Medium | Multiple machines on network |
| Cloud Build | Easy | Slow | Can't build locally |

## Recommended Workflow

1. **For Testing**: Use VirtualBox or VMware
2. **For Deployment**: Use Rufus (Windows) or Etcher (cross-platform)
3. **For Multiple Machines**: Use Ventoy or PXE boot
4. **For Permanent Install**: Use CD/DVD or internal SSD

## Troubleshooting

### USB Not Booting
- Check BIOS boot order
- Disable Secure Boot
- Try both UEFI and Legacy modes
- Ensure USB is properly formatted

### Virtual Machine Not Booting
- Increase memory to 4GB
- Enable virtualization in BIOS (VT-x/AMD-V)
- Try different virtual machine software

### Build Fails on GitHub Actions
- Check runner logs
- May need to adjust build script for CI environment
- Ensure sufficient disk space in build
