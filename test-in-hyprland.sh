#!/bin/bash
# Script to help test Caelestia shell in Hyprland
# This should be run AFTER logging into a Hyprland session (not GNOME)

set -e

echo "======================================"
echo "Caelestia Shell - Hyprland Test Script"
echo "======================================"
echo

# Check if running in Hyprland
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "❌ ERROR: Not running in Hyprland session!"
    echo
    echo "You must:"
    echo "  1. Log out from GNOME"
    echo "  2. At the login screen (GDM), click the gear icon"
    echo "  3. Select 'Hyprland'"
    echo "  4. Log in"
    echo "  5. Open a terminal and run this script again"
    echo
    exit 1
fi

echo "✓ Running in Hyprland (signature: $HYPRLAND_INSTANCE_SIGNATURE)"
echo

# Check if QML path is set
if [ -z "$QML2_IMPORT_PATH" ]; then
    echo "⚠ QML2_IMPORT_PATH not set, adding it..."
    export QML2_IMPORT_PATH="/usr/local/lib64/qt6/qml:$QML2_IMPORT_PATH"
fi

echo "✓ QML2_IMPORT_PATH: $QML2_IMPORT_PATH"
echo

# Check if Caelestia is running
if pgrep -f "caelestia shell" > /dev/null; then
    echo "✓ Caelestia shell is already running"
    echo
    echo "To restart it:"
    echo "  pkill -f 'caelestia shell'"
    echo "  caelestia shell -d"
else
    echo "⚠ Caelestia shell is not running"
    echo
    echo "Starting Caelestia shell..."
    caelestia shell -d &
    sleep 2
    
    if pgrep -f "caelestia shell" > /dev/null; then
        echo "✓ Caelestia shell started successfully!"
    else
        echo "❌ Failed to start Caelestia shell"
        echo
        echo "Check logs at: /run/user/$(id -u)/quickshell/by-id/*/log.qslog"
    fi
fi

echo
echo "======================================"
echo "Hyprland Shortcuts:"
echo "======================================"
echo "SUPER + Q          = Close window"
echo "SUPER + T          = Terminal"
echo "SUPER + M          = Exit Hyprland"
echo "SUPER + 1-9        = Switch workspace"
echo "SUPER + Mouse Drag = Move window"
echo
echo "Caelestia should provide additional UI elements:"
echo "  - Top bar with workspaces"
echo "  - Dashboard (if configured)"
echo "  - Launcher (if configured)"
echo
