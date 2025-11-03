# Caelestia Shell on Fedora 43 (⚠️ EXPERIMENTAL - CURRENTLY BROKEN)

**STATUS: NOT WORKING** - This is an attempt to port the [Caelestia shell](https://github.com/caelestia-dots/shell) (designed for Arch Linux) to Fedora 43. The build completes but **the UI is broken** when running in Hyprland.

## ⚠️ Current Issues

- UI renders incorrectly / looks broken
- Some features work, others don't
- Cross-distro compatibility issues between Arch and Fedora
- Possible Qt/QML version mismatches (Fedora uses Qt 6.10)
- Path/configuration differences from Arch Linux

**If you have ideas or suggestions to fix this, please open an issue or PR!**

## Credits

- **Original Project**: [caelestia-dots/shell](https://github.com/caelestia-dots/shell) by [@soramame](https://github.com/caelestia-dots) - **designed for Arch Linux**
- **Quickshell**: [outfoxxed/quickshell](https://git.outfoxxed.me/outfoxxed/quickshell) - the Qt6/QML-based Wayland compositor toolkit powering Caelestia
- **Hyprland**: [hyprwm/Hyprland](https://github.com/hyprwm/Hyprland) - the dynamic tiling Wayland compositor

This repository documents my attempt to build Caelestia on Fedora 43. While the components build successfully, the shell doesn't work properly yet.

## Understanding GNOME vs Hyprland

### GNOME (What Fedora Ships With)
- A **complete desktop environment** (like Windows or macOS)
- Includes everything: window manager, panel, file manager, settings, applications
- **Stable, polished, and fully supported** by Fedora
- Years of refinement - everything "just works"
- Default on Fedora because it's production-ready

### Hyprland (What Caelestia Needs)
- A **Wayland compositor only** - just the window/display manager
- **NOT a complete desktop** - it's a foundation you build on
- Requires separate components: panel, launcher, notifications, wallpaper, etc.
- Designed for **advanced users** who want total customization
- Cutting edge, less stable, requires configuration

### Why This Matters
Caelestia was built for **Arch Linux**, where package versions, paths, and configurations match what the developer tested. On **Fedora**, even though we can build all the components, there are compatibility issues with:
- Qt/QML version differences
- Runtime dependency mismatches  
- Path/configuration differences
- Theming/styling incompatibilities

**This is why cross-distro desktop shells are challenging.**

## What Caelestia Should Provide (When Working)

- **Panels/bars**: Customizable top bar with workspaces, system tray, status icons
- **Dashboard**: System info, media controls, calendar, weather
- **Launcher**: Application launcher with fuzzy search, actions, wallpaper/scheme picker
- **Lock screen**: Integrated session lock with PAM authentication
- **Notifications**: Custom notification center with grouping and actions
- **Control center**: Quick toggles for audio, network, Bluetooth, brightness

## System Requirements

- Fedora 43 (tested on Workstation)
- 8+ CPU threads recommended for building
- ~2GB free space for build artifacts
- Working Wayland session (should be default on Fedora 43)

## Installation

### 1. Install Build Dependencies

```bash
sudo dnf install -y \
  cmake ninja-build gcc-c++ \
  qt6-qtbase-devel qt6-qtbase-private-devel \
  qt6-qtdeclarative-devel qt6-qtshadertools-devel \
  qt6-qtwayland-devel qt6-qttools-devel qt6-qtsvg-devel \
  wayland-devel wayland-protocols-devel \
  libdrm-devel mesa-libgbm-devel pipewire-devel \
  pkgconf-pkg-config jemalloc-devel cli11-devel \
  polkit-devel pam-devel fftw-devel aubio-devel \
  libqalculate-devel
```

### 2. Build and Install Quickshell

```bash
# Clone Quickshell
git clone https://git.outfoxxed.me/outfoxxed/quickshell.git ~/Projects/quickshell
cd ~/Projects/quickshell

# Configure (crash reporter disabled due to missing google-breakpad on Fedora)
cmake -GNinja -B build \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DCRASH_REPORTER=OFF

# Build
cmake --build build

# Install
sudo cmake --install build
```

### 3. Build and Install libcavacore (Audio Visualizer)

```bash
# Clone cava
git clone https://github.com/karlstav/cava.git ~/Projects/cava
cd ~/Projects/cava

# Build static library with position-independent code
cmake -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON

cmake --build build

# Install library and headers
sudo install -Dm644 build/libcavacore.a /usr/local/lib/libcavacore.a
sudo install -Dm644 cavacore.h /usr/local/include/cava/cavacore.h

# Create pkg-config file
sudo mkdir -p /usr/lib64/pkgconfig
cat << 'EOF' | sudo tee /usr/lib64/pkgconfig/cava.pc
prefix=/usr/local
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: cava
Description: Cava audio spectrum core library
Version: 0.10.2
Requires: fftw3
Libs: -L${libdir} -lcavacore -lm
Cflags: -I${includedir}/cava
EOF

sudo ldconfig
```

### 4. Build and Install Caelestia Shell

```bash
# Clone Caelestia shell
git clone https://github.com/caelestia-dots/shell.git ~/Projects/caelestia-shell
cd ~/Projects/caelestia-shell

# Configure
cmake -GNinja -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/ \
  -DINSTALL_QSCONFDIR=$HOME/.config/quickshell/caelestia \
  -DINSTALL_LIBDIR=/usr/local/lib \
  -DINSTALL_QMLDIR=/usr/local/lib64/qt6/qml

# Build
cmake --build build

# Install
sudo cmake --install build
```

### 5. Install Hyprland and Runtime Dependencies

```bash
# Enable Hyprland COPR
sudo dnf copr enable solopasha/hyprland -y

# Install Hyprland
sudo dnf install -y hyprland xdg-desktop-portal-hyprland \
  hyprpaper hypridle hyprlock

# Install runtime dependencies
sudo dnf install -y swappy ddcutil brightnessctl \
  wl-clipboard lm_sensors NetworkManager fish libqalculate
```

### 6. Install Required Fonts

```bash
mkdir -p ~/.local/share/fonts

# Cascadia Code Nerd Font (mono font for terminal/code)
cd /tmp
curl -L -o CascadiaCode.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
unzip -o CascadiaCode.zip -d ~/.local/share/fonts/CaskaydiaCove

# Material Symbols Rounded (icon font)
curl -L -o MaterialSymbolsRounded.ttf \
  "https://github.com/google/material-design-icons/raw/master/font/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf"
install -Dm644 MaterialSymbolsRounded.ttf \
  ~/.local/share/fonts/MaterialSymbols/MaterialSymbolsRounded.ttf

# Rubik (UI font)
curl -L -o Rubik.ttf \
  https://github.com/google/fonts/raw/main/ofl/rubik/Rubik%5Bwght%5D.ttf
install -Dm644 Rubik.ttf ~/.local/share/fonts/Rubik/Rubik.ttf

# Refresh font cache
fc-cache -f ~/.local/share/fonts
```

### 7. Install Caelestia CLI

```bash
# Install Python build tools
python3 -m pip install --user build installer hatch hatch-vcs

# Clone CLI
git clone https://github.com/caelestia-dots/cli.git ~/Projects/caelestia-cli
cd ~/Projects/caelestia-cli

# Build wheel
python3 -m build --wheel

# Install (system-wide)
sudo python3 -m pip install dist/*.whl
```

### 8. Configure Environment

```bash
# Set QML import path for user sessions
mkdir -p ~/.config/environment.d
cat << 'EOF' > ~/.config/environment.d/50-caelestia.conf
QML2_IMPORT_PATH=/usr/local/lib64/qt6/qml:$QML2_IMPORT_PATH
EOF

# Initialize Hyprland config
mkdir -p ~/.config/hypr
cp /usr/share/hypr/hyprland.conf ~/.config/hypr/hyprland.conf

# Add Caelestia autostart to Hyprland config
cat << 'EOF' >> ~/.config/hypr/hyprland.conf

# Caelestia Shell
exec-once = caelestia shell -d
EOF
```

## Usage

1. **Log out** from your current desktop session
2. At the login screen, click the gear icon ⚙️
3. Select **"Hyprland"** from the session list
4. Log in — Caelestia shell will start automatically

### First-time Setup

After logging into Hyprland for the first time:

1. Create config directory: `mkdir -p ~/.config/caelestia`
2. (Optional) Create `~/.config/caelestia/shell.json` for customization (see [Caelestia docs](https://github.com/caelestia-dots/shell#configuring))
3. Set wallpaper directory, appearance settings, etc.

### Key Bindings (Default Hyprland)

- `Super + Q` — Close window
- `Super + Return` — Open terminal
- `Super + D` — Application launcher
- `Super + 1-9` — Switch workspace
- `Super + Mouse` — Move/resize windows

Caelestia adds its own shortcuts—check the dashboard or launcher for the full list.

## Troubleshooting

### Shell doesn't start / Black screen

Check logs:
```bash
caelestia shell -l
```

### QML module errors

Ensure environment variable is set:
```bash
echo $QML2_IMPORT_PATH
# Should include: /usr/local/lib64/qt6/qml
```

Re-import if needed:
```bash
systemctl --user import-environment QML2_IMPORT_PATH
```

### Hyprland session not showing at login

Verify session files exist:
```bash
ls /usr/share/wayland-sessions/hyprland*.desktop
```

If missing, reinstall Hyprland.

### Audio visualizer not working

Check cava library:
```bash
pkg-config --libs cava
# Should output: -L/usr/local/lib -lcavacore -lm -lfftw3
```

## Optional Enhancements

- **GPU Screen Recorder**: Install `gpu-screen-recorder` for screen recording support
- **App2unit**: Install for better app launching (not in Fedora repos; manual build needed)
- **Clipboard History**: `sudo dnf install cliphist fuzzel` for clipboard manager
- **Emoji Picker**: Included with `fuzzel`

## Known Issues & Debugging

### Current Problems
1. **UI renders broken/incorrectly** - Components don't display properly
2. **Some features work, others don't** - Inconsistent behavior
3. **Visual glitches** - Layout issues, missing elements, styling problems

### Possible Causes
- **Qt version mismatch**: Fedora 43 uses Qt 6.10, Arch may use different version
- **QML module compatibility**: Arch QML modules may not be compatible with Fedora's Qt
- **Missing runtime dependencies**: Some libs/tools may be missing or different versions
- **Configuration paths**: Hardcoded Arch-specific paths in the code
- **Theme/style issues**: GTK/Qt theming differences between distros

### Debug Steps
```bash
# Check QML errors when launching
QT_LOGGING_RULES="*.debug=true" caelestia shell -d

# Verify QML modules load
QML2_IMPORT_PATH=/usr/local/lib64/qt6/qml qmlscene --verbose

# Check Hyprland logs
cat ~/.config/hypr/hyprland.log

# Test Quickshell directly
quickshell --verbose
```

**If you know how to fix these issues, please help!** Open an issue or PR with your findings.

## Uninstalling

```bash
# Remove Caelestia shell config
rm -rf ~/.config/quickshell/caelestia

# Remove Quickshell
sudo rm /usr/local/bin/quickshell /usr/local/bin/qs

# Remove QML modules
sudo rm -rf /usr/local/lib64/qt6/qml/Caelestia

# Remove cavacore
sudo rm /usr/local/lib/libcavacore.a /usr/local/include/cava -r
sudo rm /usr/lib64/pkgconfig/cava.pc

# Remove Caelestia CLI
sudo python3 -m pip uninstall caelestia

# Remove Hyprland (optional)
sudo dnf remove hyprland hyprland-uwsm xdg-desktop-portal-hyprland
```

## Contributing

**Help Wanted!** This is an experimental port that's currently broken. Looking for contributors who can help with:
- Debugging Qt/QML compatibility issues between Arch and Fedora
- Fixing visual rendering problems
- Identifying missing or incompatible dependencies
- Creating patches for Fedora-specific paths/configurations
- Testing on different Fedora versions
- Automation scripts (single install script)
- RPM spec files for proper Fedora packaging

**Open an issue or PR if you have ideas!**

## License

- **This guide**: Public domain / CC0
- **Caelestia shell**: See [upstream LICENSE](https://github.com/caelestia-dots/shell/blob/main/LICENSE)
- **Quickshell**: GNU LGPL 3 (see [Quickshell repo](https://git.outfoxxed.me/outfoxxed/quickshell))
- **Hyprland**: BSD 3-Clause (see [Hyprland repo](https://github.com/hyprwm/Hyprland))

## Screenshots

(Add your screenshots here after installation)

## Support

- **Caelestia Issues**: [caelestia-dots/shell Issues](https://github.com/caelestia-dots/shell/issues)
- **Quickshell Issues**: [Quickshell Issues](https://git.outfoxxed.me/outfoxxed/quickshell/issues)
- **Hyprland Issues**: [Hyprland Issues](https://github.com/hyprwm/Hyprland/issues)
- **Fedora-specific build problems**: Open an issue in this repo
