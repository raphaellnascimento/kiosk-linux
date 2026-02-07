#!/bin/bash
set -e

# Chroot setup script - installs and configures the kiosk environment

export DEBIAN_FRONTEND=noninteractive
export HOME=/root
export LC_ALL=C

echo "Setting up system configuration..."

# Configure APT to not install recommended packages
cat > /etc/apt/apt.conf.d/99no-recommends << EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

# Update package lists
apt-get update

# Install essential packages
apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    live-boot \
    systemd-sysv \
    network-manager \
    wireless-tools \
    wpasupplicant \
    dbus-x11

# Install X11 and minimal window manager
apt-get install -y --no-install-recommends \
    xorg \
    openbox \
    x11-xserver-utils \
    xserver-xorg-video-all \
    xinit

# Install Chromium browser
apt-get install -y --no-install-recommends \
    chromium \
    chromium-sandbox

# Install additional utilities
apt-get install -y --no-install-recommends \
    sudo \
    ca-certificates \
    fonts-liberation \
    fonts-noto \
    pulseaudio \
    alsa-utils

# Clean up package cache
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create kiosk user
useradd -m -s /bin/bash -G audio,video kiosk
echo "kiosk:kiosk" | chpasswd

# Configure autologin
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin kiosk --noclear %I $TERM
EOF

# Create Openbox configuration
mkdir -p /home/kiosk/.config/openbox
cat > /home/kiosk/.config/openbox/autostart << 'EOF'
# Disable screen blanking
xset s off
xset -dpms
xset s noblank

# Hide cursor after 1 second of inactivity
unclutter -idle 1 -root &

# Start Chromium in kiosk mode
/usr/bin/start-kiosk-browser.sh &
EOF

chmod +x /home/kiosk/.config/openbox/autostart

# Create kiosk browser startup script
cat > /usr/bin/start-kiosk-browser.sh << 'EOF'
#!/bin/bash

# Wait for X to be ready
sleep 2

# Kill any existing Chromium instances
pkill -9 chromium || true

# Chromium kiosk mode startup
/usr/bin/chromium \
    --kiosk \
    --noerrdialogs \
    --disable-infobars \
    --disable-session-crashed-bubble \
    --disable-features=TranslateUI \
    --no-first-run \
    --disable-notifications \
    --disable-pinch \
    --overscroll-history-navigation=0 \
    --disable-popup-blocking=false \
    --user-data-dir=/home/kiosk/.config/chromium \
    "https://www.google.com" &

CHROME_PID=$!

# Monitor Chromium and restart if it crashes
while true; do
    if ! ps -p $CHROME_PID > /dev/null; then
        sleep 2
        /usr/bin/chromium --kiosk --noerrdialogs --disable-infobars \
            --disable-session-crashed-bubble --disable-features=TranslateUI \
            --no-first-run --disable-notifications --disable-pinch \
            --overscroll-history-navigation=0 --disable-popup-blocking=false \
            --user-data-dir=/home/kiosk/.config/chromium \
            "https://www.google.com" &
        CHROME_PID=$!
    fi
    sleep 5
done
EOF

chmod +x /usr/bin/start-kiosk-browser.sh

# Configure .xinitrc for kiosk user
cat > /home/kiosk/.xinitrc << 'EOF'
#!/bin/bash
exec openbox-session
EOF

chmod +x /home/kiosk/.xinitrc

# Create .bash_profile to auto-start X
cat > /home/kiosk/.bash_profile << 'EOF'
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi
EOF

# Setup DNS filtering
cat > /etc/resolv.conf << 'EOF'
# CleanBrowsing Family Filter - blocks adult content
nameserver 185.228.168.168
nameserver 185.228.169.168
EOF

# Make resolv.conf immutable
chattr +i /etc/resolv.conf || true

# Install Chromium policies for content filtering
mkdir -p /etc/chromium/policies/managed
cat > /etc/chromium/policies/managed/kiosk-policies.json << 'EOF'
{
  "ForceGoogleSafeSearch": true,
  "ForceYouTubeRestrict": 2,
  "DownloadRestrictions": 3,
  "IncognitoModeAvailability": 1,
  "DeveloperToolsDisabled": true,
  "AllowDeletingBrowserHistory": false,
  "DefaultDownloadDirectory": "/tmp",
  "DownloadDirectory": "/tmp",
  "PromptForDownloadLocation": false,
  "AllowFileSelectionDialogs": false,
  "RestoreOnStartup": 4,
  "HomepageIsNewTabPage": true,
  "BrowserSignin": 0,
  "SyncDisabled": true,
  "ExtensionInstallBlocklist": ["*"],
  "URLBlocklist": [],
  "URLAllowlist": ["*"]
}
EOF

# Copy custom configurations if they exist
if [ -f /tmp/bookmarks.json ]; then
    mkdir -p /home/kiosk/.config/chromium/Default
    cp /tmp/bookmarks.json /home/kiosk/.config/chromium/Default/Bookmarks
fi

if [ -f /tmp/blocked-domains.txt ]; then
    # Add blocked domains to hosts file
    while IFS= read -r domain; do
        if [ ! -z "$domain" ] && [ "${domain:0:1}" != "#" ]; then
            echo "0.0.0.0 $domain" >> /etc/hosts
            echo "0.0.0.0 www.$domain" >> /etc/hosts
        fi
    done < /tmp/blocked-domains.txt
fi

# Fix permissions
chown -R kiosk:kiosk /home/kiosk

# Disable unnecessary services
systemctl disable apt-daily.timer apt-daily-upgrade.timer

# Set hostname
echo "kiosk" > /etc/hostname

# Configure hosts file
cat > /etc/hosts << 'EOF'
127.0.0.1   localhost kiosk
::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
EOF

echo "Chroot setup complete!"
