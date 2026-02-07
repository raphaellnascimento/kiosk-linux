# Kiosk Linux - Browser-Only Live ISO

A stateless, locked-down Linux distribution that boots directly into a web browser with adult content filtering.

## Features

- Boots directly to Chromium browser in kiosk mode
- Blocks adult/inappropriate websites via multiple filtering layers
- Pre-configured bookmarks in the browser
- Completely stateless - resets to initial state on reboot
- No file downloads or system changes persist
- No desktop environment - just browser
- Automatic screen lock and power management

## System Requirements

- 2GB RAM minimum (4GB recommended)
- USB drive (4GB+) or CD/DVD for booting
- x86_64 processor

## Build Requirements

- Linux system (Ubuntu 22.04+ or Debian 12+ recommended)
- 20GB free disk space
- sudo/root access
- Internet connection

## Quick Start

1. Install build dependencies:
   ```bash
   sudo apt-get update
   sudo apt-get install debootstrap squashfs-tools xorriso isolinux syslinux-efi grub-pc-bin grub-efi-amd64-bin mtools
   ```

2. Build the ISO:
   ```bash
   sudo ./build-iso.sh
   ```

3. Flash to USB or burn to CD:
   ```bash
   sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress
   ```

## Configuration

### Bookmarks

Edit `config/bookmarks.json` to customize the default bookmarks.

### Content Filtering

Edit `config/blocked-domains.txt` to add domains to block.

### Browser Settings

Edit `config/chrome-policies.json` to customize browser behavior.

## Architecture

- Base: Debian minimal
- Display: X11 + Openbox (minimal window manager)
- Browser: Chromium in kiosk mode
- Filtering: DNS-level + Chromium policies
- Persistence: None (overlayfs with tmpfs)

## Security Features

- Read-only root filesystem
- No package installation possible
- No terminal access
- Adult content blocking via:
  - Filtered DNS servers (CleanBrowsing Family Filter)
  - SafeSearch enforcement
  - Domain blacklist
  - SSL certificate validation

## Customization

See `docs/CUSTOMIZATION.md` for details on:
- Adding more bookmarks
- Customizing the homepage
- Adjusting content filters
- Changing browser appearance
- Setting up auto-login credentials

## License

MIT License
