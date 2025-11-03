# Caelestia Shell - Fedora 43 Build Guide

Complete build and installation guide for running the Caelestia desktop shell on Fedora 43 with Hyprland.

## What is this?

[Caelestia](https://github.com/caelestia-dots/shell) is a beautiful, animated desktop environment built with Quickshell (Qt6/QML) for Hyprland. Originally designed for Arch Linux, this repo provides **Fedora-specific instructions** to build and run it on Fedora 43.

**⚠️ Important**: Caelestia requires Hyprland compositor. It will NOT work on GNOME.

**Credit**: All UI/shell code belongs to the [Caelestia project](https://github.com/caelestia-dots) by [@soramame](https://github.com/caelestia-dots). This repo provides Fedora build instructions and helper scripts.

## Quick Start

See [README.md](../README.md) for complete installation instructions.

**Already built it?** 
1. Log out from GNOME
2. Select "Hyprland" at login screen
3. Log in - Caelestia will auto-start

## What's Included

- **Complete build guide** - Step-by-step instructions for Fedora 43
- **Source code** - Full Caelestia shell QML source in `caelestia-source/`
- **Helper scripts** - Test script for verifying Hyprland setup
- **Documentation** - Technical analysis and Hyprland beginner's guide
- **Troubleshooting** - Common issues and solutions

## What We're Actually Doing

1. **Building Quickshell** — A compositor toolkit that lets you write desktop shells in QML (like a modern, declarative GTK/Qt but for Wayland compositors)
2. **Building libcavacore** — Audio spectrum visualization library (the cool audio bars)
3. **Installing Caelestia shell** — The actual UI components (panels, dashboard, launcher, etc.) written in QML
4. **Setting up Hyprland** — The tiling Wayland compositor that Caelestia runs on top of
5. **Integrating everything** — Making sure Hyprland launches Caelestia on login, fonts work, environment variables are set

The result: When you log into "Hyprland" instead of GNOME, you get the Caelestia UI as your desktop.
