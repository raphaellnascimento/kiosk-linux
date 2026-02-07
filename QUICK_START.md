# Quick Start Guide

Get your kiosk Linux ISO up and running in 3 steps.

## Prerequisites

- Linux machine with Ubuntu 22.04+ or Debian 12+
- 20GB free disk space
- Internet connection
- USB drive (4GB+) or blank CD/DVD

## Step 1: Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y debootstrap squashfs-tools xorriso isolinux syslinux-efi grub-pc-bin grub-efi-amd64-bin mtools
```

## Step 2: Build the ISO

```bash
cd quiosqueLinux
sudo ./build-iso.sh
```

This will take 10-20 minutes depending on your internet speed and system performance.

## Step 3: Flash to USB

Find your USB drive:
```bash
lsblk
```

Flash the ISO (replace `/dev/sdX` with your USB drive):
```bash
sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync
```

**WARNING**: This will erase everything on the USB drive!

## Boot the Kiosk

1. Insert USB into target machine
2. Boot from USB (may need to press F12, F2, or DEL during startup)
3. System will automatically boot into browser kiosk mode
4. Browser opens with pre-configured bookmarks

## What You Get

- Browser-only interface (Chromium in kiosk mode)
- Adult content blocking via:
  - CleanBrowsing Family Filter DNS
  - Google SafeSearch enforcement
  - YouTube Restricted Mode
  - Custom domain blacklist
- Pre-configured bookmarks
- No downloads allowed
- Completely stateless (resets on reboot)
- No access to terminal or system settings

## Customize Before Building

### Change Bookmarks

Edit `config/bookmarks.json` and modify the URLs and names:

```json
{
  "name": "My Website",
  "url": "https://example.com"
}
```

### Block Specific Sites

Add domains to `config/blocked-domains.txt`:

```
badsite.com
another-blocked-site.com
```

### Change Homepage

Edit `scripts/setup-chroot.sh` and find this line:

```bash
"https://www.google.com" &
```

Replace with your preferred homepage.

### After Changes

Rebuild the ISO:
```bash
sudo ./build-iso.sh
```

## Common Issues

### "Must be root" Error
Run with `sudo`:
```bash
sudo ./build-iso.sh
```

### USB Won't Boot
1. Check BIOS/UEFI settings
2. Disable Secure Boot
3. Enable USB boot
4. Try legacy BIOS mode

### No Network
- Wait 30 seconds for network to initialize
- Check WiFi connection in network settings
- Verify internet connectivity

### Sites Not Blocked
- DNS filtering may take a few seconds
- Some sites may bypass DNS filtering
- Add specific domains to `config/blocked-domains.txt`

## Next Steps

- Read `README.md` for detailed information
- See `docs/CUSTOMIZATION.md` for advanced options
- Check `docs/TROUBLESHOOTING.md` if you have problems

## Security Notes

This kiosk system provides basic protection suitable for public or family use:

- **DNS-level filtering**: Blocks adult content at the DNS level
- **Browser policies**: Enforces SafeSearch and YouTube restrictions
- **Download blocking**: Prevents file downloads
- **No system access**: Users cannot access terminal or settings
- **Stateless**: Everything resets on reboot

For enterprise deployments, consider additional security measures:
- BIOS password protection
- Disable USB ports in BIOS
- Physical security for the computer
- Network-level firewall rules
- Regular security audits

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check the troubleshooting guide
- Review Chromium policy documentation
