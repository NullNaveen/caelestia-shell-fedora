# Caelestia Shell - Fedora 43 Setup

Build and installation guide for the Caelestia desktop shell on Fedora 43.

## What is this?

[Caelestia](https://github.com/caelestia-dots/shell) is a beautiful, animated desktop environment built with Quickshell (Qt6/QML) for Hyprland. This repo provides Fedora-specific instructions and automation since Caelestia isn't packaged for Fedora yet.

**Credit**: All UI/shell code belongs to the [Caelestia project](https://github.com/caelestia-dots). This repo just makes it easy to build on Fedora.

## Quick Start

See [README.md](README.md) for full installation steps.

## What We're Actually Doing

1. **Building Quickshell** — A compositor toolkit that lets you write desktop shells in QML (like a modern, declarative GTK/Qt but for Wayland compositors)
2. **Building libcavacore** — Audio spectrum visualization library (the cool audio bars)
3. **Installing Caelestia shell** — The actual UI components (panels, dashboard, launcher, etc.) written in QML
4. **Setting up Hyprland** — The tiling Wayland compositor that Caelestia runs on top of
5. **Integrating everything** — Making sure Hyprland launches Caelestia on login, fonts work, environment variables are set

The result: When you log into "Hyprland" instead of GNOME, you get the Caelestia UI as your desktop.
