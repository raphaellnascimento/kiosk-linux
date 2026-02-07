#!/bin/bash

# Alternative Docker build using Ubuntu (often faster to download)

set -e

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

# Check if Docker is running
if ! docker info &> /dev/null; then
    error "Docker is not running. Please start Docker Desktop and try again."
fi

log "Testing Docker Hub connectivity..."
if ! docker pull ubuntu:22.04 2>&1 | tail -5; then
    error "Cannot connect to Docker Hub. Check your network/firewall settings."
fi

log "Building with Ubuntu base image (faster download)..."
docker build -f Dockerfile.alternative -t kiosk-linux-builder .

log "Running build inside Docker container..."
log "This will take 10-20 minutes..."

# Create output directory
mkdir -p output

# Run the build
docker run --rm --privileged \
    -v "$(pwd)/output:/output" \
    kiosk-linux-builder \
    /bin/bash -c "cd /build && ./build-iso.sh && cp kiosk-linux.iso /output/"

if [ -f "output/kiosk-linux.iso" ]; then
    log "Build successful!"
    log "ISO location: $(pwd)/output/kiosk-linux.iso"

    ISO_SIZE=$(du -h output/kiosk-linux.iso | cut -f1)
    log "ISO size: $ISO_SIZE"

    log "Compressing ISO..."
    gzip -9 -c output/kiosk-linux.iso > output/kiosk-linux.iso.gz
    COMPRESSED_SIZE=$(du -h output/kiosk-linux.iso.gz | cut -f1)
    log "Compressed size: $COMPRESSED_SIZE"

    echo ""
    echo "Upload to Google Drive: output/kiosk-linux.iso.gz"
else
    error "Build failed!"
fi
