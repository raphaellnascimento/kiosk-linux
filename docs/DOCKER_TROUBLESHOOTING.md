# Docker Build Troubleshooting

## Network Timeout Errors

If you see `TLS handshake timeout` or `failed to resolve source metadata` errors:

### Solution 1: Restart Docker Desktop

```bash
# macOS - Restart Docker
osascript -e 'quit app "Docker"'
sleep 5
open -a Docker
# Wait 30 seconds for Docker to fully start
```

### Solution 2: Check Network Connectivity

```bash
# Test if Docker Hub is reachable
ping -c 3 registry-1.docker.io

# If ping fails, check your internet connection
curl -I https://hub.docker.com
```

### Solution 3: Configure Docker DNS

1. Open Docker Desktop
2. Click Settings (gear icon)
3. Go to "Docker Engine"
4. Add DNS configuration:

```json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

5. Click "Apply & Restart"

### Solution 4: Use Docker Mirror (for users in certain regions)

If Docker Hub is slow or blocked in your region:

1. Open Docker Desktop → Settings → Docker Engine
2. Add mirror configuration:

```json
{
  "registry-mirrors": [
    "https://mirror.gcr.io"
  ]
}
```

### Solution 5: Use Alternative Base Image

If Debian image won't download, try Ubuntu instead:

```bash
# Use the alternative Dockerfile
docker build -f Dockerfile.alternative -t kiosk-linux-builder .
```

### Solution 6: Pre-pull Base Image

Try pulling the image separately first:

```bash
# Pull Debian image manually
docker pull debian:bookworm-slim

# If that fails, try Ubuntu
docker pull ubuntu:22.04

# Then run the build
./build-with-docker.sh
```

### Solution 7: Check Proxy Settings

If you're behind a corporate proxy:

1. Docker Desktop → Settings → Resources → Proxies
2. Enable "Manual proxy configuration"
3. Enter your proxy details
4. Apply & Restart

### Solution 8: Increase Timeout

Edit `Dockerfile` and add timeout configuration:

```dockerfile
FROM debian:bookworm-slim

# Add at the top
ENV DOCKER_BUILDKIT=1
ENV BUILDKIT_STEP_LOG_MAX_SIZE=10485760
```

### Solution 9: Use Different Registry

Edit `Dockerfile` to use a different registry:

```dockerfile
# Instead of:
FROM debian:bookworm-slim

# Use:
FROM quay.io/debian/debian:bookworm-slim
```

## VPN Issues

If you're using a VPN:

1. Try disabling VPN temporarily
2. Or configure Docker to work with VPN:
   - Docker Desktop → Settings → Resources → Network
   - Try switching between "vpnkit" and "host networking"

## Firewall Issues

If corporate firewall is blocking:

1. Check with IT department about Docker Hub access
2. Use GitHub Actions instead (cloud build, no local network needed)
3. Or use a remote Linux server

## Still Not Working?

### Alternative: Use GitHub Actions

No Docker needed, builds in the cloud:

```bash
# Push to GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/kiosk-linux.git
git push -u origin main

# Build runs automatically in GitHub's servers
# Download from Actions → Artifacts
```

See `docs/CLOUD_BUILD.md` for full instructions.

### Alternative: Use Remote Linux Server

If you have access to a Linux server:

```bash
# Upload files
scp -r . user@server:/path/

# SSH and build
ssh user@server
cd /path/
sudo ./build-iso.sh

# Download result
scp user@server:/path/kiosk-linux.iso ./
```

## Verify Docker is Working

Test with a simple container:

```bash
# Try pulling a small image
docker pull hello-world

# Run it
docker run hello-world

# If this works, Docker is fine and the issue is network-specific
```

## Check Docker Status

```bash
# Check if Docker daemon is running
docker info

# Check Docker version
docker --version

# View Docker logs
# macOS: ~/Library/Containers/com.docker.docker/Data/log/
```

## Clean Docker Cache

If previous failed builds are causing issues:

```bash
# Remove all unused containers, networks, images
docker system prune -a

# Remove build cache
docker builder prune -a

# Then try building again
./build-with-docker.sh
```

## Update Docker Desktop

Sometimes old Docker versions have network bugs:

1. Check for updates: Docker Desktop → Check for Updates
2. Or download latest from: https://www.docker.com/products/docker-desktop

## Region-Specific Issues

### China
Use mirror: `https://docker.mirrors.ustc.edu.cn`

### India
Use mirror: `https://mirror.gcr.io`

### Other regions with slow Docker Hub
Try: `https://mirror.gcr.io` or ask your local Docker community

## Last Resort: Build Without Docker

If nothing works, use one of these:

1. **GitHub Actions** (recommended) - builds in cloud
2. **Local Linux VM** - Use VirtualBox with Ubuntu
3. **Remote server** - Use any Linux cloud server
4. **WSL2** (Windows only) - Windows Subsystem for Linux

See `docs/CLOUD_BUILD.md` for alternatives.
