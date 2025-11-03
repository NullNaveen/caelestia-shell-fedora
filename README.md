# Caelestia Shell on Fedora 43

Build guide and resources for running the [Caelestia shell](https://github.com/caelestia-dots/shell) on Fedora 43 with Hyprland.

## ⚠️ Important: Requires Hyprland

**Caelestia only works with Hyprland compositor.** It will NOT work on GNOME.

If you try to run it on GNOME, you'll see errors like:
- "Failed to initialize layershell integration" 
- Broken/missing UI elements
- Non-functional features

**Solution**: Log into Hyprland session instead (see [Quick Start](#quick-start)).

**Why?** Caelestia uses Hyprland-specific Wayland protocols that GNOME doesn't support. See [TECHNICAL_ANALYSIS.md](TECHNICAL_ANALYSIS.md) for details.

## Quick Start

### If You Haven't Built It Yet
Follow the [Installation](#installation) section below.

### If You Already Built It
1. **Log out** from your current session
2. At the GDM login screen, **click the gear icon** (bottom right)
3. Select **"Hyprland"**
4. Log in with your password
5. Caelestia should auto-start with the UI

**New to Hyprland?** Read [HYPRLAND_GUIDE.md](HYPRLAND_GUIDE.md) for essential keybindings and tips.

**Need Help Testing?** Run the test script:
```bash
~/Projects/caelestia-shell-fedora/test-in-hyprland.sh
```

## Credits

- **Original Project**: [caelestia-dots/shell](https://github.com/caelestia-dots/shell) by [@soramame](https://github.com/caelestia-dots) - originally designed for Arch Linux
- **Quickshell**: [outfoxxed/quickshell](https://git.outfoxxed.me/outfoxxed/quickshell) - the Qt6/QML-based Wayland compositor toolkit powering Caelestia
- **Hyprland**: [hyprwm/Hyprland](https://github.com/hyprwm/Hyprland) - the dynamic tiling Wayland compositor

This repository provides Fedora-specific build instructions and helper scripts to get Caelestia running on Fedora 43.

## Understanding GNOME vs Hyprland

**Quick Answer**: GNOME and Hyprland are completely different systems. Caelestia **requires** Hyprland.

### GNOME (What Fedora Ships With)
- Complete desktop environment (like Windows or macOS)
- Everything integrated: window manager, panel, file manager, settings
- Stable, polished, "just works"
- Uses GNOME Shell and Mutter compositor

### Hyprland (What Caelestia Needs)
- Wayland compositor only (just manages windows and displays)
- You build your desktop on top of it
- Tiling window manager by default
- Highly customizable for power users
- Uses wlroots-based protocols

**Why Caelestia Needs Hyprland**: It uses Hyprland-specific Wayland protocols (layer-shell, IPC, shortcuts) that GNOME doesn't provide. Running it on GNOME is like trying to run iOS apps on Android - wrong platform.

**Detailed Explanation**: See [TECHNICAL_ANALYSIS.md](TECHNICAL_ANALYSIS.md)

**New to Hyprland?**: See [HYPRLAND_GUIDE.md](HYPRLAND_GUIDE.md) for a beginner-friendly guide

## What You Get

Caelestia provides a beautiful, modern desktop shell with:

- **Top Bar**: Workspaces, active window title, system tray, status icons, clock
- **Dashboard**: System info, media controls, calendar, weather widgets
- **Launcher**: Fuzzy-search app launcher with actions, wallpaper/scheme picker
- **Lock Screen**: Integrated session lock with PAM authentication  
- **Notifications**: Custom notification center with grouping and actions
- **Control Center**: Quick toggles for audio, network, Bluetooth, brightness
- **OSD**: On-screen displays for volume, brightness, etc.

**Visual Style**: Material Design 3 inspired, smooth animations, customizable themes

## System Requirements

- Fedora 43 (tested on Workstation)
- 8+ CPU threads recommended for building
- ~2GB free space for build artifacts
- Working Wayland session (should be default on Fedora 43)

## Installation

### Option 1: Automated Install (Recommended)

Run the automated installer script:

```bash
cd ~/Projects/caelestia-shell-fedora
./install.sh
```

This will:
- Install all dependencies
- Build Quickshell, libcavacore, and Caelestia modules
- Install Hyprland and fonts
- Configure your environment
- Set up autostart

**Time**: ~30-60 minutes depending on your system

### Option 2: Manual Install

Follow the steps below for manual installation.

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

## Debugging Tips

### Check if Caelestia is running
```bash
ps aux | grep caelestia
```

### View Caelestia logs
```bash
caelestia shell -l
```

### Check Hyprland logs
```bash
cat ~/.config/hypr/hyprland.log
```

### Test QML modules manually
```bash
QML2_IMPORT_PATH=/usr/local/lib64/qt6/qml qmlscene
```

### Enable verbose Quickshell output
```bash
QT_LOGGING_RULES="*.debug=true" caelestia shell -d
```

### Verify all dependencies
```bash
# Check Qt version
qmake6 --version

# Check QML import path
echo $QML2_IMPORT_PATH

# Check cava library
pkg-config --libs cava

# Check Hyprland version
hyprctl version
```

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

Contributions welcome! Areas where you can help:
- Testing on different Fedora versions (41, 42, 44)
- Creating automation scripts (single install script)
- RPM spec files for proper Fedora packaging
- Improving documentation and troubleshooting guides
- Adding patches for Fedora-specific optimizations
- Reporting bugs specific to Fedora build

**Open an issue or PR!**

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
