# rn-codespace

A ready-to-use **React Native 0.84 Android** starter template, pre-configured for
[GitHub Codespaces](https://github.com/features/codespaces).

---

## Contents

| Path | Description |
|------|-------------|
| `MyApp/` | React Native 0.84 starter app (New Architecture enabled, Hermes JS engine) |
| `.devcontainer/` | Codespaces / VS Code Dev Container configuration |
| `.devcontainer/setup.sh` | One-shot bootstrap: installs SDK components, creates AVD, installs npm deps |

---

## Quick Start — GitHub Codespaces (recommended)

1. Click **Code → Codespaces → Create codespace on main**.  
   The devcontainer will automatically call `.devcontainer/setup.sh` which:
   - accepts Android SDK licences
   - installs `emulator`, `platform-tools`, `build-tools;34.0.0`, `platforms;android-34`
   - downloads the `system-images;android-34;google_apis;x86_64` system image
   - creates an AVD named **Pixel6_API34** (Pixel 6, API 34)
   - runs `npm install` inside `MyApp/`

2. Open a terminal and launch the emulator in the background:

   ```bash
   $ANDROID_SDK_ROOT/emulator/emulator -avd Pixel6_API34 -no-audio -no-window &
   adb wait-for-device
   ```

   > In a Codespace with GPU support you can remove `-no-window` and use the
   > built-in noVNC desktop (port 6080).

3. Start Metro and run the app:

   ```bash
   cd MyApp
   npx react-native start          # keep this terminal open
   # in a second terminal:
   npx react-native run-android
   ```

---

## Quick Start — Local Machine

### Prerequisites

| Tool | Minimum version | Notes |
|------|-----------------|-------|
| Node.js | 18 LTS | [nodejs.org](https://nodejs.org) |
| JDK | 17 | [Adoptium Temurin](https://adoptium.net) |
| Android Studio / SDK | API 34 | [developer.android.com/studio](https://developer.android.com/studio) |
| Android SDK CLI tools | latest | Install from Android Studio → SDK Manager |

Set these environment variables (add to `~/.bashrc` / `~/.zshrc`):

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk          # macOS
# export ANDROID_HOME=$HOME/Android/Sdk                # Linux
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

### Install SDK components

```bash
sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34" \
           "emulator" "system-images;android-34;google_apis;x86_64"
```

### Create an AVD

```bash
avdmanager create avd \
  --name Pixel6_API34 \
  --package "system-images;android-34;google_apis;x86_64" \
  --device "pixel_6"
```

### Run the app

```bash
# 1. Start emulator
emulator -avd Pixel6_API34 &

# 2. Install deps
cd MyApp && npm install

# 3. Launch
npx react-native start &          # Metro bundler
npx react-native run-android
```

---

## Project Structure (MyApp)

```
MyApp/
├── android/          # Native Android project
│   ├── app/          # App module (build.gradle, src/)
│   ├── build.gradle  # Root Gradle build (buildToolsVersion, compileSdkVersion …)
│   └── gradle.properties
├── ios/              # Native iOS project
├── src/              # (add your screens/components here)
├── App.tsx           # Root component
├── index.js          # Entry point
└── package.json      # RN 0.84, New Architecture enabled
```

### Key Android configuration

| Setting | Value |
|---------|-------|
| React Native | 0.84.0 |
| compileSdkVersion | 36 |
| targetSdkVersion | 36 |
| minSdkVersion | 24 (Android 7.0+) |
| New Architecture (Fabric + TurboModules) | ✅ enabled |
| Hermes JS engine | ✅ enabled |
| NDK | 27.3.13750724 |

---

## Useful Commands

```bash
# Check connected devices / running emulators
adb devices

# See Metro logs
cd MyApp && npx react-native start --reset-cache

# Build a release APK
cd MyApp/android && ./gradlew assembleRelease

# List available AVDs
avdmanager list avd

# Delete an AVD
avdmanager delete avd --name Pixel6_API34
```

---

## Troubleshooting

**`sdk.dir` not found**  
Create `MyApp/android/local.properties` with:
```
sdk.dir=/path/to/your/Android/sdk
```
This file is git-ignored and must exist on every machine.

**Emulator won't start in a headless environment**  
Add `-no-audio -no-window` flags and make sure KVM is available:
```bash
sudo apt-get install -y qemu-kvm && ls -la /dev/kvm
```

**Metro bundler port already in use**  
```bash
npx react-native start --port 8082
```
