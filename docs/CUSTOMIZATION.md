# Customization Guide

This guide explains how to customize various aspects of the Kiosk Linux system.

## Bookmarks

Edit `config/bookmarks.json` to add, remove, or modify bookmarks. The bookmarks appear in the browser's bookmark bar.

### Adding a New Bookmark

Add a new entry to the `children` array:

```json
{
  "date_added": "13300000000000000",
  "date_last_used": "0",
  "guid": "00000000-0000-0000-0001-000000000005",
  "id": "9",
  "name": "My Website",
  "type": "url",
  "url": "https://example.com"
}
```

Make sure to:
- Increment the `id` field
- Use a unique `guid`
- Set the correct `url`

## Homepage

To change the default homepage, edit `scripts/setup-chroot.sh` and modify the URL in the `start-kiosk-browser.sh` script:

```bash
"https://www.google.com" &
```

Replace `https://www.google.com` with your desired homepage.

## Content Filtering

### DNS-Level Filtering

The system uses CleanBrowsing Family Filter DNS servers by default. To use different DNS servers, edit `scripts/setup-chroot.sh` and modify the `/etc/resolv.conf` section:

```bash
nameserver 185.228.168.168  # CleanBrowsing Family Filter
nameserver 185.228.169.168  # CleanBrowsing Family Filter backup
```

Alternative family-safe DNS servers:
- **OpenDNS FamilyShield**: `208.67.222.123` and `208.67.220.123`
- **Quad9 with malware blocking**: `9.9.9.9` and `149.112.112.112`
- **AdGuard Family Protection**: `94.140.14.15` and `94.140.15.16`

### Domain Blacklist

Add specific domains to block in `config/blocked-domains.txt`:

```
adult-site.com
gambling-site.com
social-media-site.com
```

These domains will be added to `/etc/hosts` pointing to `0.0.0.0`.

### Browser Policies

Edit `config/chrome-policies.json` to modify browser restrictions:

- `ForceGoogleSafeSearch`: Enforce safe search (true/false)
- `ForceYouTubeRestrict`: YouTube restriction mode (0=off, 1=moderate, 2=strict)
- `DownloadRestrictions`: Download restrictions (0=allow all, 3=block all)
- `IncognitoModeAvailability`: Incognito mode (0=allowed, 1=disabled)
- `DeveloperToolsDisabled`: Disable dev tools (true/false)

## Browser Appearance

### Disable Bookmark Bar

Edit `scripts/setup-chroot.sh` and add to the Chromium launch command:

```bash
--disable-bookmark-bar \
```

### Full Screen Without UI

The `--kiosk` flag already hides most UI elements. For additional customization:

```bash
--app="https://www.google.com" \  # App mode instead of kiosk
--start-fullscreen \               # Full screen
--disable-bookmark-bar \           # No bookmarks
```

## Keyboard Shortcuts

To disable specific keyboard shortcuts, add to the Chromium launch command in `start-kiosk-browser.sh`:

```bash
--disable-features=GlobalMediaControls \
```

To completely disable keyboard shortcuts, you'll need to configure Openbox keyboard bindings in the setup script.

## Network Configuration

### Static IP Address

Add to `scripts/setup-chroot.sh` before the final cleanup:

```bash
cat > /etc/network/interfaces << 'EOF'
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
EOF
```

### WiFi Configuration

Create a Network Manager connection:

```bash
nmcli connection add \
    type wifi \
    con-name "MyWiFi" \
    ifname wlan0 \
    ssid "MySSID" \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk "MyPassword"
```

Add this to the setup script to have WiFi preconfigured.

## Session Timeout

To automatically refresh the browser after inactivity:

Edit `scripts/setup-chroot.sh` and create a timeout script:

```bash
cat > /usr/bin/kiosk-timeout.sh << 'EOF'
#!/bin/bash
TIMEOUT=300  # 5 minutes in seconds

while true; do
    IDLE=$(xprintidle)
    if [ $IDLE -gt $((TIMEOUT * 1000)) ]; then
        # Reload browser
        xdotool key F5
    fi
    sleep 10
done
EOF

chmod +x /usr/bin/kiosk-timeout.sh
```

Then add to Openbox autostart:
```bash
/usr/bin/kiosk-timeout.sh &
```

## Allowed Websites Only (Whitelist Mode)

To only allow specific websites, modify `config/chrome-policies.json`:

```json
{
  "URLBlocklist": ["*"],
  "URLAllowlist": [
    "google.com",
    "*.google.com",
    "youtube.com",
    "*.youtube.com",
    "wikipedia.org",
    "*.wikipedia.org"
  ]
}
```

This will block all sites except those in the allowlist.

## Custom Splash Screen

To add a custom boot splash screen:

1. Create a Plymouth theme or use a simple boot message
2. Add Plymouth package to the installation in `setup-chroot.sh`
3. Configure Plymouth to show your custom image

## Additional Software

To include additional software packages, edit `scripts/setup-chroot.sh` and add packages to the `apt-get install` commands:

```bash
apt-get install -y --no-install-recommends \
    chromium \
    chromium-sandbox \
    your-package-here
```

## Security Hardening

For additional security:

1. Disable USB ports in BIOS
2. Set BIOS password
3. Disable boot from other devices
4. Add firewall rules to block outgoing connections to specific ports
5. Enable SELinux or AppArmor for additional sandboxing

## Rebuild After Changes

After making any configuration changes, rebuild the ISO:

```bash
sudo ./build-iso.sh
```

Then flash the new ISO to your boot media.
