#!/bin/bash

# Docker-based ISO builder for macOS/Windows users

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    error "Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    error "Docker is not running. Please start Docker Desktop and try again."
fi

log "Building Docker image for Intel/AMD64 architecture..."
docker build --platform linux/amd64 -t kiosk-linux-builder .

log "Running build inside Docker container..."
log "This will take 10-20 minutes depending on your internet connection..."

# Run the build inside Docker with privileged mode (needed for debootstrap)
docker run --rm --privileged --platform linux/amd64 \
    -v "$(pwd)/output:/output" \
    kiosk-linux-builder \
    /bin/bash -c "cd /build && ./build-iso.sh && cp kiosk-linux.iso /output/"

if [ -f "output/kiosk-linux.iso" ]; then
    log "Build successful!"
    log "ISO location: $(pwd)/output/kiosk-linux.iso"

    # Calculate size and checksum
    ISO_SIZE=$(du -h output/kiosk-linux.iso | cut -f1)
    log "ISO size: $ISO_SIZE"

    # Compress the ISO
    log "Compressing ISO for easier upload..."
    if command -v gzip &> /dev/null; then
        gzip -9 -c output/kiosk-linux.iso > output/kiosk-linux.iso.gz
        COMPRESSED_SIZE=$(du -h output/kiosk-linux.iso.gz | cut -f1)
        log "Compressed size: $COMPRESSED_SIZE"
        log "Compressed file: $(pwd)/output/kiosk-linux.iso.gz"
    else
        warn "gzip not found, skipping compression"
    fi

    echo ""
    echo "Next steps:"
    echo "1. Upload output/kiosk-linux.iso.gz (or .iso) to Google Drive"
    echo "2. Download on your other computer"
    echo "3. Decompress if needed: gunzip kiosk-linux.iso.gz"
    echo "4. Flash to USB using Rufus (Windows) or Etcher"
else
    error "Build failed! Check the output above for errors."
fi
