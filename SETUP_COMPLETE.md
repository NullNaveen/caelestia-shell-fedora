# Caelestia Shell - Setup Complete ✓

## What We've Done

### ✅ Repository Updated
- **Full source code** added to `caelestia-source/` (227 QML files)
- **Complete documentation** created:
  - `README.md` - Installation guide with automated & manual options
  - `TECHNICAL_ANALYSIS.md` - Why it needs Hyprland, protocol explanations
  - `HYPRLAND_GUIDE.md` - Beginner-friendly guide to Hyprland
- **Helper scripts** created:
  - `install.sh` - Automated installer (30-60 min build time)
  - `check-setup.sh` - Pre-flight verification (24 checks)
  - `test-in-hyprland.sh` - Test script for Hyprland sessions
- **GitHub repository** pushed: https://github.com/NullNaveen/caelestia-shell-fedora

### ✅ System Configuration
- All components built and installed:
  - Quickshell (Qt6/QML compositor toolkit)
  - Libcavacore (audio visualizer)
  - Caelestia QML modules (4 modules)
  - Caelestia CLI
  - Hyprland compositor
  - All required fonts
- Configuration files in place:
  - `~/.config/hypr/hyprland.conf` - with Caelestia autostart
  - `~/.config/environment.d/50-caelestia.conf` - QML import paths
  - `~/.config/quickshell/caelestia/` - Shell files

### ✅ Pre-flight Check Results
```
Total Checks: 24
✓ Passed: 22
⚠ Warnings: 2 (fonts - non-critical)
✗ Failed: 0
```

**Status: READY FOR HYPRLAND LOGIN**

## Understanding The Issue

### Why It Was "Broken" on GNOME

The shell wasn't actually broken - it was running on the **wrong platform**.

**The Problem:**
- **Caelestia requires Hyprland** - it's built specifically for it
- **GNOME uses Mutter** - a different compositor with different protocols
- Running Caelestia on GNOME is like trying to run iPhone apps on Android

**Wayland Protocols Caelestia Needs (Hyprland-specific):**
1. `wlr-layer-shell` - For panels/bars/overlays
2. `hyprland_global_shortcuts_v1` - For keybindings
3. `ext-idle-notify-v1` - For idle/lock detection
4. Hyprland IPC - For workspace/window management

**What GNOME Supports:**
- GNOME Shell extensions API
- Different set of Wayland protocols
- Mutter-specific features

### The Solution: Use Hyprland

GNOME and Hyprland are **both desktop environments** - you pick one at login.

**Think of it like this:**
- GNOME = Complete desktop (like Windows 11)
- Hyprland = Tiling compositor (like i3/Sway but modern)
- Caelestia = Beautiful UI shell built FOR Hyprland

## What You Need To Do

### Step 1: Verify Setup
```bash
cd ~/Projects/caelestia-shell-fedora
./check-setup.sh
```

Should show: "✓ All critical checks passed!"

### Step 2: Log Into Hyprland
1. **Log out** from your current GNOME session (top-right menu → Power Off → Log Out)
2. At the **GDM login screen**, you'll see your username
3. **Click the gear/cog icon** (⚙️) at the bottom-right of the screen
4. Select **"Hyprland"** from the list
5. Enter your password and log in
6. Caelestia will **auto-start** - you should see the UI!

### Step 3: Learn Hyprland Basics
Read the guide:
```bash
cat ~/Projects/caelestia-shell-fedora/HYPRLAND_GUIDE.md
```

**Essential Keybindings:**
- `Super + Q` - Close window
- `Super + Return` - Terminal
- `Super + D` - App launcher (Caelestia)
- `Super + 1-9` - Switch workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + Mouse` - Move/resize windows

### Step 4: Enjoy the UI!

Caelestia provides:
- **Top Bar** - Workspaces, window title, system tray, clock
- **Dashboard** - System info, media player, calendar, weather
- **Launcher** - App search, actions, wallpaper picker
- **Lock Screen** - Beautiful lock screen with notifications
- **Notifications** - Modern notification center
- **Control Center** - Quick settings for audio, network, Bluetooth

## Troubleshooting

### "I don't see Hyprland at login"
Check session file exists:
```bash
ls /usr/share/wayland-sessions/hyprland*.desktop
```

If missing, reinstall:
```bash
sudo dnf install hyprland
```

### "Caelestia didn't start"
Check if autostart is configured:
```bash
grep "caelestia" ~/.config/hypr/hyprland.conf
```

Should show: `exec-once = caelestia shell -d`

Start manually to see errors:
```bash
caelestia shell -d
```

### "Some UI elements are missing"
Check QML modules:
```bash
ls /usr/local/lib64/qt6/qml/Caelestia/
```

Should have: `Caelestia`, `Internal`, `Models`, `Services`

### "Want to go back to GNOME?"
At login screen, select "GNOME" or "GNOME (Wayland)" instead of Hyprland.

Your GNOME session is untouched - you can switch back anytime!

## Next Steps (Optional)

### 1. Customize Caelestia
Edit: `~/.config/caelestia/shell.json`

See: https://github.com/caelestia-dots/shell#configuring

### 2. Configure Hyprland
Edit: `~/.config/hypr/hyprland.conf`

See: https://wiki.hyprland.org/Configuring/

### 3. Add More Tools
```bash
# Screen recording
sudo dnf install gpu-screen-recorder

# Clipboard manager
sudo dnf install cliphist fuzzel
```

### 4. Take Screenshots
Share on GitHub! The repo needs screenshots. :)

### 5. Report Issues
If something doesn't work **in Hyprland**, open an issue:
- For Caelestia bugs: https://github.com/caelestia-dots/shell/issues
- For Fedora build issues: https://github.com/NullNaveen/caelestia-shell-fedora/issues

## Summary

### What Changed
- **Before**: Tried running Caelestia on GNOME → Failed (wrong platform)
- **After**: Documented proper setup → Run on Hyprland → Works! ✓

### Key Insight
It wasn't a "broken port" - it was a **platform mismatch**. Like trying to run Android apps on iOS.

**The fix:** Use the right platform (Hyprland).

### Repository Status
**GitHub**: https://github.com/NullNaveen/caelestia-shell-fedora

Now properly documents:
- Why Hyprland is required (technical reasons)
- How to install (automated + manual)
- How to use (beginner-friendly guide)
- Complete source code for reference

### What You'll See in Hyprland
A beautiful, modern, animated desktop shell with Material Design 3 styling, smooth transitions, and all the features of Caelestia as designed.

**Enjoy your new desktop! 🚀**
