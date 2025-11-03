# Technical Analysis: Why Caelestia Doesn't Work on GNOME

## Core Issue

Caelestia shell is hardcoded to use **Hyprland-specific Wayland protocols and APIs** that don't exist in GNOME's Mutter compositor.

## Failed Components

### 1. Layer Shell (`Failed to initialize layershell integration`)
- **What it is**: wlr-layer-shell protocol for creating panels/bars that overlay the desktop
- **Hyprland**: Fully supported (based on wlroots)
- **GNOME**: Not supported (uses different protocol)
- **Impact**: Top bars, panels, overlays completely fail to render

### 2. Hyprland IPC (`$HYPRLAND_INSTANCE_SIGNATURE is unset`)
- **What it is**: Direct socket communication with Hyprland for workspace/window control
- **Hyprland**: Core functionality
- **GNOME**: Doesn't exist
- **Impact**: Workspace switching, window management, all Hyprland integration broken

### 3. Global Shortcuts (`hyprland_global_shortcuts_v1 not supported`)
- **What it is**: Hyprland's custom protocol for system-wide keyboard shortcuts
- **Hyprland**: Native protocol
- **GNOME**: Uses different keybinding system
- **Impact**: All keyboard shortcuts don't work

### 4. Idle Detection (`ext-idle-notify-v1 not supported`)
- **What it is**: Protocol for detecting user inactivity
- **Hyprland**: Supported via wlroots
- **GNOME**: Uses different idle detection
- **Impact**: Auto-lock and idle features don't work

## Why Cross-Distro Porting Isn't the Problem

The issue isn't Fedora vs Arch - it's **Hyprland vs GNOME**.

Even on Arch, running Caelestia on GNOME would fail the same way. The shell requires:
- Hyprland's Wayland compositor
- wlr-layer-shell protocol
- Hyprland IPC socket
- Hyprland-specific protocols

## Solutions

### Option 1: Use Hyprland (Recommended)
**Status**: Already installed, just needs proper login

1. Log out from GNOME
2. Select "Hyprland" at GDM login screen
3. Caelestia will work as designed

**Pros**: 
- Zero code changes needed
- Gets the exact intended UI
- All features work

**Cons**: 
- Different window management paradigm (tiling)
- Must learn Hyprland keybindings
- Different from GNOME workflow

### Option 2: Create GNOME Shell Extension
**Status**: Would require complete rewrite

Recreate Caelestia's visual design as a GNOME Shell extension using:
- GNOME Shell's panel APIs
- GTK instead of QML
- GNOME's DBus interfaces

**Pros**: 
- Works in GNOME
- Keeps familiar GNOME workflow

**Cons**: 
- Months of development work
- Different technology stack (GTK vs Qt)
- Won't be "Caelestia", just inspired by it

### Option 3: Hybrid Approach
**Status**: Experimental

Use Hyprland but configure it to feel more like GNOME:
- Add floating window rules
- Configure mouse-based workflow
- Disable tiling for most windows

**Pros**: 
- Gets Caelestia UI
- Can make it less "tiling-focused"

**Cons**: 
- Still requires learning some Hyprland
- Configuration complexity

## Recommendation

**Use Hyprland properly.** The shell was designed for it, it's already installed, and it will work correctly.

The "broken" state comes from running it on the wrong compositor (GNOME), not from Fedora compatibility issues.

## Testing Steps

1. Ensure Hyprland session is available:
   ```bash
   ls /usr/share/wayland-sessions/hyprland.desktop
   ```

2. Log out and select Hyprland at login

3. Run test script:
   ```bash
   ~/Projects/caelestia-shell-fedora/test-in-hyprland.sh
   ```

4. Caelestia should render correctly with all features working
