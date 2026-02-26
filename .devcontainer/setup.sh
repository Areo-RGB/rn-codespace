#!/usr/bin/env bash
# .devcontainer/setup.sh
# Post-create setup for React Native Android development in GitHub Codespaces.
# Run this script once after the devcontainer is created.

set -euo pipefail

ANDROID_SDK="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
SDKMANAGER="$ANDROID_SDK/cmdline-tools/latest/bin/sdkmanager"
AVDMANAGER="$ANDROID_SDK/cmdline-tools/latest/bin/avdmanager"

echo "=== React Native Android – Codespace Setup ==="

# ── 1. Accept SDK licences ────────────────────────────────────────────────────
echo "Accepting Android SDK licences..."
yes | "$SDKMANAGER" --licenses > /dev/null 2>&1 || true

# ── 2. Install required SDK components ───────────────────────────────────────
echo "Installing SDK components..."
"$SDKMANAGER" \
  "platform-tools" \
  "build-tools;34.0.0" \
  "platforms;android-34" \
  "emulator" \
  "system-images;android-34;google_apis;x86_64"

# ── 3. Create Android Virtual Device (Pixel 6 / API 34) ──────────────────────
AVD_NAME="Pixel6_API34"
if ! "$AVDMANAGER" list avd | grep -q "$AVD_NAME"; then
  echo "Creating AVD: $AVD_NAME ..."
  echo "no" | "$AVDMANAGER" create avd \
    --name "$AVD_NAME" \
    --package "system-images;android-34;google_apis;x86_64" \
    --device "pixel_6" \
    --force
fi

# ── 4. Install JavaScript dependencies ───────────────────────────────────────
APP_DIR="$(dirname "$0")/../MyApp"
if [ -f "$APP_DIR/package.json" ]; then
  echo "Installing npm dependencies..."
  npm install --prefix "$APP_DIR"
fi

echo ""
echo "✅  Setup complete!"
echo ""
echo "   Start the Metro bundler:  cd MyApp && npx react-native start"
echo "   Launch the emulator:      $ANDROID_SDK/emulator/emulator -avd $AVD_NAME &"
echo "   Run on device/emulator:   cd MyApp && npx react-native run-android"
