# Cloud Build Guide - Build ISO Without Local Linux

Since building requires Linux and you're on macOS/Windows, you have two options:

## Option 1: Docker Build (Recommended for macOS)

### Prerequisites
1. Install Docker Desktop: https://www.docker.com/products/docker-desktop
2. Start Docker Desktop
3. Open Terminal/Command Prompt

### Build Process

```bash
# Make the script executable
chmod +x build-with-docker.sh

# Run the build (takes 10-20 minutes)
./build-with-docker.sh
```

This will:
1. Build a Docker image with all dependencies
2. Run the ISO build inside the container
3. Output the ISO to `output/kiosk-linux.iso`
4. Compress it to `output/kiosk-linux.iso.gz`

### After Build

The compressed ISO will be in the `output/` folder:
- `kiosk-linux.iso.gz` (compressed, ~300-400MB)
- `kiosk-linux.iso` (original, ~500-800MB)

Upload the `.gz` file to Google Drive for easier transfer.

---

## Option 2: GitHub Actions (Free Cloud Build)

Build the ISO in GitHub's cloud servers - no local resources needed!

### Setup

1. **Create GitHub Repository**
   ```bash
   # Initialize git if not already done
   git init

   # Add files
   git add .

   # Commit
   git commit -m "Initial commit - Kiosk Linux"

   # Create repo on GitHub (via web interface)
   # Then push
   git remote add origin https://github.com/YOUR_USERNAME/kiosk-linux.git
   git branch -M main
   git push -u origin main
   ```

2. **Trigger Build**
   - Go to your GitHub repository
   - Click "Actions" tab
   - Click "Build Kiosk Linux ISO"
   - Click "Run workflow"
   - Select branch: `main`
   - Click "Run workflow"

3. **Wait for Build** (15-25 minutes)
   - Watch the progress in the Actions tab
   - Green checkmark = success

4. **Download ISO**
   - Click on the completed workflow run
   - Scroll to "Artifacts" section
   - Download `kiosk-linux-iso`
   - Extract the zip file
   - You'll get `kiosk-linux.iso.gz`

### Automatic Builds

The workflow runs automatically on:
- Every push to `main` branch
- Every pull request
- Manual trigger via Actions tab

### Creating Releases

To create a downloadable release:

```bash
# Tag a version
git tag v1.0.0
git push origin v1.0.0
```

The ISO will automatically attach to the GitHub release!

---

## Comparison: Docker vs GitHub Actions

| Feature | Docker | GitHub Actions |
|---------|--------|----------------|
| Setup | Install Docker | Create GitHub account |
| Build Time | 10-20 min | 15-25 min |
| Resources | Uses your Mac | Uses GitHub servers |
| Internet | Downloads once | Downloads every build |
| Storage | Local | GitHub (90 days) |
| Best For | Multiple builds | One-time or automated |

---

## Upload to Google Drive

### From macOS/Windows

1. Go to https://drive.google.com
2. Click "New" → "File upload"
3. Select `kiosk-linux.iso.gz` (compressed version)
4. Wait for upload (5-15 minutes depending on connection)
5. Right-click file → "Share"
6. Set to "Anyone with the link"
7. Copy link

### Using Command Line (Optional)

Install `gdrive` tool:

```bash
# macOS
brew install gdrive

# Upload
gdrive upload kiosk-linux.iso.gz
```

---

## Download and Flash on Another Computer

### 1. Download from Google Drive

- Open the shared link
- Click "Download"
- Save to Downloads folder

### 2. Decompress (if needed)

**Windows:**
- Use 7-Zip: https://www.7-zip.org/
- Right-click → 7-Zip → Extract Here

**macOS:**
```bash
gunzip kiosk-linux.iso.gz
```

**Linux:**
```bash
gunzip kiosk-linux.iso.gz
```

### 3. Flash to USB

**Windows - Rufus:**
1. Download Rufus: https://rufus.ie/
2. Insert USB drive
3. Select `kiosk-linux.iso`
4. Click "START"

**macOS - Etcher:**
1. Download Etcher: https://etcher.balena.io/
2. Insert USB drive
3. Select `kiosk-linux.iso`
4. Click "Flash!"

**Linux:**
```bash
sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync
```

---

## Verify Download Integrity

After downloading, verify the file wasn't corrupted:

```bash
# Check MD5
md5sum kiosk-linux.iso
# Compare with kiosk-linux.iso.md5

# Or SHA256
sha256sum kiosk-linux.iso
# Compare with kiosk-linux.iso.sha256
```

---

## File Sizes Reference

- **Uncompressed ISO**: ~500-800 MB
- **Compressed (.gz)**: ~300-400 MB (50% reduction)
- **USB drive needed**: 4 GB minimum

---

## Troubleshooting

### Docker Build Fails

**"Cannot connect to Docker daemon"**
- Start Docker Desktop
- Wait for it to fully start (whale icon in system tray)

**"Permission denied"**
```bash
# macOS/Linux - add sudo
sudo ./build-with-docker.sh
```

**"No space left on device"**
- Free up at least 20 GB disk space
- Clean Docker: `docker system prune -a`

### GitHub Actions Fails

**"Disk space full"**
- The workflow includes cleanup steps
- If it still fails, the ISO might be too large
- Try reducing the included packages

**"Workflow not found"**
- Ensure `.github/workflows/build-iso.yml` exists
- Push the file to GitHub
- Check Actions tab is enabled in repository settings

### Upload Too Slow

- Compress the ISO first: `gzip -9 kiosk-linux.iso`
- Use resumable upload tools
- Split into smaller parts if needed

---

## Alternative: Remote Linux Server

If you have access to a remote Linux server:

```bash
# Upload project to server
scp -r . user@server:/path/to/build/

# SSH to server
ssh user@server

# Build
cd /path/to/build/
sudo ./build-iso.sh

# Download ISO
# On your local machine:
scp user@server:/path/to/build/kiosk-linux.iso ./
```

---

## Next Steps After Download

1. Decompress if needed
2. Verify checksum (optional but recommended)
3. Flash to USB using Rufus/Etcher
4. Boot on target machine
5. Test all features work correctly
6. Deploy to production machines

---

## Cost Considerations

| Method | Cost | Notes |
|--------|------|-------|
| Docker Build | Free | Uses your electricity |
| GitHub Actions | Free | 2000 minutes/month free tier |
| Google Drive | Free | 15 GB free storage |
| Remote Server | Varies | If you already have one |

All methods above are completely free for this use case!
