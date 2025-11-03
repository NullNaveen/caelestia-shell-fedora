# ⚠️ IMPORTANT: Audio Crackling Issue - NOT Related to Caelestia

## If You're Experiencing Audio Problems

**Symptoms**: Loud crackling, popping, or distorted audio on laptop speakers

**This is NOT caused by Caelestia or Hyprland!**

### The Real Cause

**AMD Ryzen laptop audio power management bug** - affects:
- AMD Family 17h/19h/1ah HD Audio Controllers
- Both Linux AND Windows
- Particularly ASUS Vivobook, HP Pavilion, Lenovo IdeaPad with AMD

### Why It Seems Related

The timing made it seem connected to Caelestia installation, but:
1. The bug exists in **Windows too** (Caelestia doesn't run on Windows)
2. Caelestia only **reads** audio data for visualization
3. It doesn't change any hardware settings
4. The power management bug is at the **kernel/hardware level**

### The Fix (Linux)

Create `/etc/modprobe.d/audio-powersave-fix.conf`:
```bash
sudo tee /etc/modprobe.d/audio-powersave-fix.conf << 'EOF'
# Fix AMD audio crackling/popping noise
options snd_hda_intel power_save=0 power_save_controller=N
EOF

sudo dracut -f
reboot
```

### The Fix (Windows)

1. **Device Manager** → **Sound controllers**
2. Right-click **AMD High Definition Audio** → **Properties**
3. **Power Management** tab → Uncheck "Allow computer to turn off this device"
4. **OK** → Reboot

### More Info

See the complete guide: `/home/nick/AMD_AUDIO_FIX.md`

---

**Caelestia is safe to use.** The audio issue is a hardware quirk, not a software bug.
