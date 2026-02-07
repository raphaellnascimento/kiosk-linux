# Force Intel/AMD64 architecture (for Apple Silicon Macs)
FROM --platform=linux/amd64 debian:bookworm-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /build

# Copy project files
COPY . /build/

# Make scripts executable
RUN chmod +x /build/build-iso.sh /build/scripts/setup-chroot.sh

# Build command will be run when container starts
CMD ["/bin/bash"]
