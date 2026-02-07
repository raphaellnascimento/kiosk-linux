# EASIEST WAY - Build ISO in Cloud, Download, Upload to Google Drive

**Total time: 25 minutes (mostly waiting for build)**

## Step 1: Push to GitHub (5 minutes)

### 1a. Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `kiosk-linux`
3. Make it **Private** (or Public, your choice)
4. Click "Create repository"

### 1b. Push Your Code
```bash
cd /Users/raphaelln/work/overmind_workspace/fluent/quiosqueLinux

# Initialize git
git init
git add .
git commit -m "Kiosk Linux with Brazilian bookmarks"

# Push (replace YOUR_USERNAME with your GitHub username!)
git remote add origin https://github.com/YOUR_USERNAME/kiosk-linux.git
git branch -M main
git push -u origin main
```

If it asks for credentials, use a Personal Access Token:
- Go to https://github.com/settings/tokens
- Generate new token (classic)
- Select "repo" scope
- Use the token as password

---

## Step 2: Build in GitHub (15-20 minutes)

1. Go to your repository: `https://github.com/YOUR_USERNAME/kiosk-linux`
2. Click **"Actions"** tab (top menu)
3. You'll see "Build Kiosk Linux ISO" workflow
4. Click on it
5. Click **"Run workflow"** button (top right)
6. Select branch: `main`
7. Click **"Run workflow"** (green button)

Now **wait 15-20 minutes**. GitHub will build your ISO in their cloud servers!

Watch the progress - it will show:
- ⏳ Yellow = Building
- ✅ Green = Success
- ❌ Red = Failed (let me know if this happens)

---

## Step 3: Download ISO (2 minutes)

1. Once build is complete (green checkmark ✅)
2. Click on the completed workflow run
3. Scroll down to **"Artifacts"** section
4. Click **"kiosk-linux-iso"** to download
5. It will download as a ZIP file (~300-400 MB)
6. Extract the ZIP - you'll get `kiosk-linux.iso.gz`
7. Decompress: `gunzip kiosk-linux.iso.gz` → You get `kiosk-linux.iso`

---

## Step 4: Upload to Google Drive (5-10 minutes)

1. Go to https://drive.google.com
2. Click **"New"** → **"File upload"**
3. Select `kiosk-linux.iso` (or upload the .gz version if you want smaller size)
4. Wait for upload to complete
5. Right-click the file → **"Share"**
6. Change to **"Anyone with the link"**
7. Copy the sharing link
8. Send link to your other computer

---

## Step 5: On Your Other Computer (5 minutes)

### Download from Google Drive
1. Open the Google Drive link
2. Click **"Download"**
3. Wait for download

### Decompress (if needed)
```bash
# If you uploaded .gz version
gunzip kiosk-linux.iso.gz
```

### Flash to USB
```bash
# Find USB drive
lsblk

# Flash (replace sdX with your drive!)
sudo dd if=kiosk-linux.iso of=/dev/sdX bs=4M status=progress && sync
```

### Boot and Use!
1. Insert USB in target computer
2. Boot from USB
3. Browser opens automatically with your bookmarks!

---

## What You Get

✅ Custom Debian-based kiosk
✅ Your Brazilian bookmarks pre-configured:
   - Globo
   - UOL
   - Gazeta do Povo
   - YouTube
   - ESPN Brasil
   - Gazeta Esportiva

✅ Adult content filtering (DNS + SafeSearch)
✅ No downloads allowed
✅ Resets on reboot
✅ Browser-only interface
✅ Works on Intel/AMD computers

---

## Summary Timeline

- Push to GitHub: **5 min**
- GitHub builds ISO: **15-20 min** (automatic, just wait)
- Download from GitHub: **2 min**
- Upload to Google Drive: **5-10 min** (depends on internet)
- Download on other computer: **5-10 min**
- Flash to USB: **5 min**

**Total active work: ~20 minutes**
**Total waiting time: ~20 minutes**

---

## Why This Is Best For You

✅ No Mac limitations
✅ No Docker networking issues
✅ No USB needed on Mac
✅ Build happens in cloud (free)
✅ Can download anywhere
✅ Can share link with others
✅ Reproducible - run build again anytime

---

## Need Help?

If the GitHub Actions build fails, share the error log and I'll help fix it!
