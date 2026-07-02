#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "🚀 ClearSwap Setup"
echo "=================="

# Install XcodeGen if missing
if ! command -v xcodegen &>/dev/null; then
  echo "Installing XcodeGen..."
  if command -v brew &>/dev/null; then
    brew install xcodegen
  else
    echo "❌ Homebrew not found. Install XcodeGen manually: https://github.com/yonaskolb/XcodeGen"
    exit 1
  fi
fi

# Point xcode-select to Xcode.app if available
if [ -d "/Applications/Xcode.app" ]; then
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer 2>/dev/null || true
fi

echo "Generating Xcode project..."
xcodegen generate

echo ""
echo "✅ Project generated: ClearSwap.xcodeproj"
echo ""
echo "Next steps:"
echo "  1. Open ClearSwap.xcodeproj in Xcode 16+"
echo "  2. Set your Development Team in Signing & Capabilities"
echo "  3. Enable Pass Type ID in Apple Developer portal (for Wallet passes)"
echo "  4. Build & Run on iPhone 15/16 Pro (iOS 18+) for Live Activities"
echo ""
echo "Demo flow:"
echo "  Settings → Seller Mode → Deals → Fund Escrow → Start Meetup"
echo "  Settings → Buyer Mode → Deals → View → Simulate QR Scan → Wallet"
