# Porteus Kiosk Setup Guide - Pre-configured for Your Needs

## Quick Setup (10 minutes total)

### Step 1: Download Porteus Kiosk (5 minutes)

```bash
cd ~/Downloads
wget https://porteus-kiosk.org/porteus-kiosk-5.5.0.iso
```

Or download from: https://porteus-kiosk.org/download.html

### Step 2: Flash to USB (2 minutes)

```bash
# Find your USB drive
lsblk

# Flash (replace sdX with your USB drive!)
sudo dd if=porteus-kiosk-5.5.0.iso of=/dev/sdX bs=4M status=progress && sync
```

### Step 3: Boot and Configure (3 minutes)

1. **Boot from USB** on your target computer
2. **Press F12** during boot to enter configuration wizard
3. **Enter configuration mode** (it will ask for password: default is often `porteus`)

### Configuration Settings to Use:

#### Browser Settings:
- **Homepage**: https://www.google.com.br
- **Enable bookmarks toolbar**: Yes

#### Bookmarks (add these):
```
https://www.globo.com.br - Globo
https://www.uol.com.br - UOL
https://www.gazetadopovo.com.br - Gazeta do Povo
https://www.youtube.com - YouTube
https://www.espn.com.br - ESPN Brasil
https://www.gazetaesportiva.com.br - Gazeta Esportiva
```

#### Content Filtering:
- **Enable SafeSearch**: Yes
- **YouTube Restricted Mode**: Strict
- **Custom DNS servers**:
  - Primary: 185.228.168.168 (CleanBrowsing Family Filter)
  - Secondary: 185.228.169.168

#### Security Settings:
- **Allow downloads**: No
- **Allow printing**: No (or Yes if you want)
- **Allow file upload**: No
- **Disable right-click**: Yes
- **Disable keyboard shortcuts**: Yes
- **Hide URL bar**: No (users need to type URLs)

#### Kiosk Behavior:
- **Full screen mode**: Yes
- **Auto-start browser**: Yes
- **Reset on inactivity**: Optional (e.g., 10 minutes)
- **Block browser exit**: Yes

#### Network:
- **DHCP**: Yes (or configure static IP if needed)
- **WiFi**: Configure if needed

### Step 4: Save Configuration

1. Save settings
2. Reboot
3. System will start in kiosk mode with your settings!

---

## Alternative: Pre-configure Before Flashing

If you want to pre-configure settings, Porteus Kiosk uses a wizard config file. However, this is proprietary.

**Easier approach**: Just use the wizard once, it takes 3 minutes and is very user-friendly!

---

## Troubleshooting

### Can't Access Configuration Wizard
- Press F12 or ESC during boot
- Default password: `porteus` or check documentation

### Need to Reconfigure Later
- Reboot and press F12 again
- Or use the web-based configuration interface (if enabled)

### WiFi Not Working
- Use Ethernet for first setup
- Configure WiFi in the wizard

---

## After Setup

The system will:
- ✅ Boot directly to browser
- ✅ Show your bookmarks
- ✅ Block adult content via DNS
- ✅ Enforce SafeSearch
- ✅ Block downloads
- ✅ Reset on reboot
- ✅ Users can browse any non-adult site

---

## Advantages Over Our Custom Build

- ⚡ 10 minutes vs 25+ minutes
- 🔧 GUI configuration (easier)
- 🏢 Professional support available
- 🔄 Easy updates
- 📱 Remote management available
- 🎯 Built specifically for kiosks

---

## If You Need Multiple Machines

1. Configure one USB as above
2. In wizard, export configuration
3. Import configuration on other machines
4. Or use their fleet management (paid feature)
