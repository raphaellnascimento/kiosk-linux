# Quick Kiosk Setup on Xubuntu

## Easiest Option: Download Pre-Made Kiosk ISO

Run these commands on your Xubuntu machine:

```bash
cd ~/Downloads

# Option 1: Webconverger (Recommended - Lightweight)
wget https://dl.webconverger.com/latest.iso -O kiosk.iso

# OR Option 2: Porteus Kiosk (More features)
wget https://porteus-kiosk.org/porteus-kiosk-5.5.0.iso -O kiosk.iso
```

## Flash to USB

```bash
# Find your USB drive
lsblk

# Flash (replace sdX with your drive, e.g., sdb)
sudo dd if=kiosk.iso of=/dev/sdX bs=4M status=progress && sync
```

## Configure Your Bookmarks

### For Webconverger:
1. Boot from USB
2. Press TAB at boot menu
3. Add this to boot parameters:
```
bookmarks="https://www.globo.com.br|Globo,https://www.uol.com.br|UOL,https://www.gazetadopovo.com.br|Gazeta,https://www.youtube.com|YouTube,https://www.espn.com.br|ESPN,https://www.gazetaesportiva.com.br|Gazeta Esportiva" dns1=185.228.168.168
```

### For Porteus Kiosk:
1. Boot from USB
2. Press F12 at boot
3. Enter password: `porteus`
4. Add your bookmarks in the GUI wizard
5. Set DNS to: 185.228.168.168, 185.228.169.168
6. Enable SafeSearch
7. Save and reboot

## That's It!

Takes 10 minutes total:
- Download: 5 min
- Flash: 2 min
- Configure: 3 min

## Features You Get:

✅ Browser-only kiosk mode
✅ Adult content blocked (DNS filtering)
✅ SafeSearch enforced
✅ Resets on reboot
✅ Users can browse any safe site
✅ No downloads allowed

---

## Alternative: If Downloads Fail

Use a browser to download:
- **Webconverger**: https://webconverger.com/download/
- **Porteus Kiosk**: https://porteus-kiosk.org/download.html

Then flash with Etcher (GUI) or dd (command line).
