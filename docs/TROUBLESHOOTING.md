# Troubleshooting Guide

## Build Issues

### Error: "debootstrap: command not found"

Install required dependencies:
```bash
sudo apt-get install debootstrap squashfs-tools xorriso isolinux syslinux-efi grub-pc-bin grub-efi-amd64-bin mtools
```

### Error: "Must be root to run"

Run the build script with sudo:
```bash
sudo ./build-iso.sh
```

### Build fails with "No space left on device"

Ensure you have at least 20GB free space in the build directory.

## Boot Issues

### System doesn't boot from USB

1. Ensure USB was written correctly:
   ```bash
   sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync
   ```

2. Check BIOS/UEFI settings:
   - Enable USB boot
   - Disable Secure Boot
   - Set USB as first boot device

3. Try legacy BIOS mode instead of UEFI

### Black screen after boot

1. Wait 30-60 seconds (first boot takes longer)
2. Try pressing Ctrl+Alt+F2 to access terminal
3. Check if video drivers are loading correctly

### Keyboard not working

Some USB keyboards need extra time to initialize. Try:
- Using a PS/2 keyboard
- Connecting keyboard before boot
- Adding boot parameter: `udev.log_priority=3`

## Browser Issues

### Browser doesn't start

1. Check if X server is running: `ps aux | grep X`
2. Check logs: `cat /home/kiosk/.xsession-errors`
3. Try starting manually from terminal as kiosk user

### Browser crashes repeatedly

1. Clear browser cache (it's in /tmp so reboot clears it)
2. Check available RAM: `free -h`
3. Increase RAM allocation if running in VM

### Cannot exit kiosk mode

This is by design. To exit:
- Press Ctrl+Alt+F2 to access terminal
- Login as root (if you set a password)
- Or reboot the system

## Network Issues

### No internet connection

1. Check if network interface is up: `ip link`
2. Check if DNS is working: `ping 8.8.8.8`
3. Verify DNS configuration: `cat /etc/resolv.conf`
4. For WiFi: `nmcli device wifi list`

### WiFi not connecting

1. Check if wireless is enabled: `nmcli radio wifi`
2. Enable if needed: `nmcli radio wifi on`
3. Connect manually:
   ```bash
   nmcli device wifi connect "SSID" password "PASSWORD"
   ```

### Filtered DNS not working

If CleanBrowsing DNS is not working:
1. Check `/etc/resolv.conf` is set correctly
2. Try alternative DNS servers (OpenDNS FamilyShield)
3. Ensure DNS servers are reachable: `ping 185.228.168.168`

## Content Filtering Issues

### Adult content getting through

Multi-layer approach:

1. Verify DNS servers in `/etc/resolv.conf`
2. Check Chrome policies: `/etc/chromium/policies/managed/kiosk-policies.json`
3. Add specific domains to `/config/blocked-domains.txt` and rebuild
4. Enable SafeSearch enforcement in browser policies

### Legitimate sites being blocked

1. Check if domain is in `/etc/hosts` blacklist
2. Try different DNS servers (some are more aggressive)
3. Add to URLAllowlist in Chrome policies

## Performance Issues

### Slow boot time

1. First boot is always slower (unpacking squashfs)
2. Subsequent boots should be faster
3. Use USB 3.0 ports for faster I/O
4. Consider using SSD instead of USB drive

### Browser sluggish

1. Ensure adequate RAM (4GB recommended)
2. Close unnecessary tabs
3. Clear browser cache (reboot)
4. Check CPU usage

## Persistence Issues

### Changes not persisting after reboot

This is the expected behavior. The system is stateless by design.

To make changes persistent:
1. Modify configuration files in the source
2. Rebuild the ISO
3. Flash new ISO to boot media

## Hardware Compatibility

### Touch screen not working

Add to kernel parameters in isolinux.cfg:
```
i8042.direct i8042.dumbkbd
```

### No sound

1. Check PulseAudio: `pactl info`
2. Verify ALSA: `aplay -l`
3. Unmute: `amixer set Master unmute`

### Screen resolution wrong

Add to Openbox autostart:
```bash
xrandr --output HDMI-1 --mode 1920x1080
```

## Getting Logs

To debug issues, collect logs:

```bash
# System log
journalctl -b

# X server log
cat /var/log/Xorg.0.log

# Browser log
cat /home/kiosk/.xsession-errors

# Kernel messages
dmesg
```

## Emergency Access

If you need to access the system:

1. **Terminal access**: Press Ctrl+Alt+F2
2. **Login**: username `kiosk`, password `kiosk`
3. **Root access**: If enabled, switch with `su -`

## Reporting Issues

When reporting issues, include:
- ISO build date/version
- Hardware specifications
- Boot mode (UEFI/Legacy)
- Full error messages
- Relevant log files

## Recovery

If system is completely broken:

1. Boot from another Linux live USB
2. Mount the kiosk USB
3. Verify files are intact
4. Re-flash if necessary

## Additional Resources

- Chromium policy list: https://chromeenterprise.google/policies/
- Debian live documentation: https://live-team.pages.debian.net/live-manual/
- Openbox documentation: http://openbox.org/wiki/Help:Contents
