#!/bin/bash

# Quick script to push to GitHub

echo "=========================================="
echo "  Push Kiosk Project to GitHub"
echo "=========================================="
echo ""

# Initialize git if not already
if [ ! -d .git ]; then
    git init
    echo "✅ Git initialized"
fi

# Add all files
git add .
git commit -m "Kiosk Linux with Brazilian bookmarks and content filtering" || echo "Already committed"

echo ""
echo "Next steps:"
echo ""
echo "1. Create a new repository on GitHub:"
echo "   https://github.com/new"
echo "   Name it: kiosk-linux"
echo ""
echo "2. Then run these commands:"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/kiosk-linux.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. After pushing, go to:"
echo "   https://github.com/YOUR_USERNAME/kiosk-linux/actions"
echo ""
echo "4. Click 'Build Kiosk Linux ISO' → 'Run workflow'"
echo ""
echo "5. Wait 15-20 minutes for build to complete"
echo ""
echo "6. Download ISO from 'Artifacts' section"
echo ""
echo "7. Upload to Google Drive"
echo ""
echo "Done! 🎉"
