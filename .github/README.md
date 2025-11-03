# Caelestia Shell - Fedora 43 Attempt (⚠️ BROKEN)

**STATUS: EXPERIMENTAL - NOT WORKING**

Attempt to build the Caelestia desktop shell (designed for Arch Linux) on Fedora 43. Build completes, but **the UI is broken** when running.

## What is this?

[Caelestia](https://github.com/caelestia-dots/shell) is a beautiful, animated desktop environment built with Quickshell (Qt6/QML) for Hyprland. **It was designed for Arch Linux.**

This repo documents my attempt to port it to Fedora 43. The build process succeeds, but the shell has severe UI issues - rendering is broken, features don't work correctly, and the experience is unusable.

**Credit**: All UI/shell code belongs to the [Caelestia project](https://github.com/caelestia-dots) by [@soramame](https://github.com/caelestia-dots). This is purely a Fedora porting attempt.

## Current Status

❌ **UI broken** - Components don't render properly  
❌ **Inconsistent behavior** - Some features work, others don't  
❌ **Visual glitches** - Layout issues, styling problems  

**Looking for help!** If you know how to debug Qt/QML cross-distro issues, please contribute.

## Quick Start

See [README.md](../README.md) for build instructions (and known issues).

## What We're Actually Doing

1. **Building Quickshell** — A compositor toolkit that lets you write desktop shells in QML (like a modern, declarative GTK/Qt but for Wayland compositors)
2. **Building libcavacore** — Audio spectrum visualization library (the cool audio bars)
3. **Installing Caelestia shell** — The actual UI components (panels, dashboard, launcher, etc.) written in QML
4. **Setting up Hyprland** — The tiling Wayland compositor that Caelestia runs on top of
5. **Integrating everything** — Making sure Hyprland launches Caelestia on login, fonts work, environment variables are set

The result: When you log into "Hyprland" instead of GNOME, you get the Caelestia UI as your desktop.
