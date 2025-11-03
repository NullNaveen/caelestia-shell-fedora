# Hyprland Quick Start Guide for GNOME Users

If you're coming from GNOME, Hyprland will feel different. This guide helps you get productive quickly.

## What's Different?

### GNOME (What You're Used To)
- **Floating windows** by default (like Windows/macOS)
- Click to focus, drag to move
- Alt+Tab to switch windows
- Activities overview for app launching

### Hyprland (What You're Getting)
- **Tiling windows** by default (windows auto-arrange)
- Keyboard-focused workflow
- Workspaces on number keys
- Can be configured for mouse/floating if preferred

## Essential Keybindings

### Window Management
| Action | Keys | Notes |
|--------|------|-------|
| **Close window** | `SUPER + Q` | Like Alt+F4 in GNOME |
| **Open terminal** | `SUPER + T` | Default terminal |
| **Toggle floating** | `SUPER + V` | Make window float like in GNOME |
| **Toggle fullscreen** | `SUPER + F` | |
| **Move focus** | `SUPER + Arrow Keys` | Or use mouse click |
| **Move window** | `SUPER + Shift + Arrow Keys` | Or SUPER + drag |
| **Resize window** | `SUPER + Right-click + drag` | |

### Workspaces
| Action | Keys | Notes |
|--------|------|-------|
| **Switch workspace** | `SUPER + 1-9` | Like GNOME workspace switching |
| **Move window to workspace** | `SUPER + Shift + 1-9` | |
| **Cycle workspaces** | `SUPER + Mouse Wheel` | On empty desktop |

### System
| Action | Keys | Notes |
|--------|------|-------|
| **Exit Hyprland** | `SUPER + M` | Return to GDM login |
| **Lock screen** | *Caelestia provides this* | Check Caelestia docs |

## Making Hyprland Feel More Like GNOME

Edit `~/.config/hypr/hyprland.conf` and add these settings:

```bash
# Make new windows float by default (more GNOME-like)
windowrulev2 = float, class:.*

# Or keep tiling but make specific apps float:
windowrulev2 = float, class:firefox
windowrulev2 = float, class:nautilus
windowrulev2 = float, class:gnome-calculator

# Enable mouse window dragging without SUPER key
# (Hold left+right mouse buttons to drag any window)
bindm = , mouse:272, movewindow
```

## Caelestia-Specific Features

Once Caelestia loads, you'll have:

1. **Top Bar**: 
   - Click workspaces to switch
   - System tray and status icons
   - Clock and calendar

2. **Dashboard** (if configured):
   - Usually `SUPER + D` or similar
   - System info, media controls, calendar

3. **Launcher** (if configured):
   - Usually `SUPER + R` or similar  
   - App search and launch

4. **Quick Settings**:
   - Click system icons in top bar
   - Audio, network, brightness controls

## First Login Checklist

1. **Test if it works**:
   ```bash
   # After logging into Hyprland:
   echo $HYPRLAND_INSTANCE_SIGNATURE
   # Should output a hash, not empty
   ```

2. **Open a terminal**:
   - Press `SUPER + T`
   - Or right-click desktop (if configured)

3. **Launch apps**:
   - Use Caelestia launcher (check keybinding)
   - Or run `wofi` or `rofi` from terminal
   - Or type app name in terminal (e.g., `firefox &`)

4. **Check Caelestia is running**:
   ```bash
   pgrep -a caelestia
   ```

5. **View logs if issues**:
   ```bash
   cat /run/user/$(id -u)/quickshell/by-id/*/log.qslog
   ```

## Common Issues

### "Nothing appears / Black screen"
- Caelestia might not have auto-started
- Open terminal: `SUPER + T`
- Run: `caelestia shell -d &`

### "I can't drag windows"
- Windows are tiling by default
- Press `SUPER + V` to make a window float
- Then you can drag it normally

### "How do I get back to GNOME?"
- Press `SUPER + M` to exit Hyprland
- At login screen, click gear icon, select "GNOME"

### "Mouse doesn't work like GNOME"
- Hyprland is keyboard-first
- Click still works to focus windows
- Add mouse bindings to config (see above)

## Getting Comfortable

**Week 1**: Keep a keybinding cheat sheet open. Use mouse when stuck.

**Week 2**: Start using `SUPER + Number` for workspaces. It's faster than mouse.

**Week 3**: Learn to keep terminal open and type app names instead of clicking.

**Month 1**: You'll find yourself frustrated using GNOME because it feels slower.

## Need Help?

- Hyprland wiki: https://wiki.hyprland.org
- Caelestia config: `~/.config/quickshell/caelestia/config/`
- Hyprland config: `~/.config/hypr/hyprland.conf`
- Logs: `/run/user/$(id -u)/quickshell/by-id/*/log.qslog`

## Still Want GNOME?

If you decide Hyprland isn't for you:
1. Just select GNOME at login
2. Caelestia won't work, but you keep your familiar workflow
3. Consider trying other desktop shells designed for GNOME instead
