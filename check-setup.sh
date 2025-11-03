#!/bin/bash
# Caelestia Shell Pre-flight Check
# Verifies all dependencies and configuration before logging into Hyprland

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

check_count=0
pass_count=0
warn_count=0
fail_count=0

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Caelestia Shell Pre-flight Check    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"
}

check() {
    local name="$1"
    local command="$2"
    local required="$3"
    
    ((check_count++))
    printf "%-40s" "[$check_count] $name..."
    
    if eval "$command" &>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((pass_count++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗ FAIL${NC}"
            ((fail_count++))
        else
            echo -e "${YELLOW}⚠ WARN${NC}"
            ((warn_count++))
        fi
        return 1
    fi
}

check_file() {
    local name="$1"
    local path="$2"
    local required="$3"
    check "$name" "test -f '$path'" "$required"
}

check_dir() {
    local name="$1"
    local path="$2"
    local required="$3"
    check "$name" "test -d '$path'" "$required"
}

check_command() {
    local name="$1"
    local cmd="$2"
    local required="$3"
    check "$name" "command -v '$cmd' >/dev/null 2>&1" "$required"
}

print_summary() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Summary:${NC}"
    echo -e "  Total Checks: $check_count"
    echo -e "  ${GREEN}Passed: $pass_count${NC}"
    echo -e "  ${YELLOW}Warnings: $warn_count${NC}"
    echo -e "  ${RED}Failed: $fail_count${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}\n"
    
    if [ $fail_count -eq 0 ]; then
        echo -e "${GREEN}✓ All critical checks passed!${NC}"
        echo -e "\nYou're ready to log into Hyprland:"
        echo -e "  1. Log out from GNOME"
        echo -e "  2. Click the gear icon at login screen"
        echo -e "  3. Select 'Hyprland'"
        echo -e "  4. Log in - Caelestia will auto-start\n"
        return 0
    else
        echo -e "${RED}✗ Some critical checks failed!${NC}"
        echo -e "\nPlease fix the failed items before logging into Hyprland."
        echo -e "Run the install script if needed:\n"
        echo -e "  cd ~/Projects/caelestia-shell-fedora && ./install.sh\n"
        return 1
    fi
}

# Main checks
print_header

echo -e "${BLUE}Core Components:${NC}"
check_command "Quickshell binary" "quickshell" "required"
check_command "Hyprland binary" "hyprland" "required"
check_command "Caelestia CLI" "caelestia" "required"

echo -e "\n${BLUE}QML Modules:${NC}"
check_dir "Caelestia QML module" "/usr/local/lib64/qt6/qml/Caelestia" "required"
check_dir "Caelestia Internal module" "/usr/local/lib64/qt6/qml/Caelestia/Internal" "required"
check_dir "Caelestia Models module" "/usr/local/lib64/qt6/qml/Caelestia/Models" "required"
check_dir "Caelestia Services module" "/usr/local/lib64/qt6/qml/Caelestia/Services" "required"

echo -e "\n${BLUE}Libraries:${NC}"
check_file "libcavacore library" "/usr/local/lib/libcavacore.a" "required"
check_file "cava pkg-config" "/usr/lib64/pkgconfig/cava.pc" "required"

echo -e "\n${BLUE}Configuration Files:${NC}"
check_file "Hyprland config" "$HOME/.config/hypr/hyprland.conf" "required"
check_file "Environment config" "$HOME/.config/environment.d/50-caelestia.conf" "required"
check_dir "Caelestia shell files" "$HOME/.config/quickshell/caelestia" "required"
check_file "shell.qml" "$HOME/.config/quickshell/caelestia/shell.qml" "required"

echo -e "\n${BLUE}Session Files:${NC}"
check_file "Hyprland session" "/usr/share/wayland-sessions/hyprland.desktop" "required"

echo -e "\n${BLUE}Runtime Dependencies:${NC}"
check_command "swappy" "swappy" "optional"
check_command "brightnessctl" "brightnessctl" "optional"
check_command "wl-clipboard" "wl-copy" "optional"
check_command "sensors" "sensors" "optional"
check_command "NetworkManager" "nmcli" "optional"

echo -e "\n${BLUE}Fonts:${NC}"
check "CaskaydiaCove Nerd Font" "fc-list | grep -i cascadia" "optional"
check "Material Symbols" "fc-list | grep -i 'Material.*Symbols'" "optional"
check "Rubik font" "fc-list | grep -i rubik" "optional"

echo -e "\n${BLUE}Configuration Checks:${NC}"
check "QML path in env" "grep -q 'QML2_IMPORT_PATH' ~/.config/environment.d/50-caelestia.conf" "required"
check "Caelestia autostart" "grep -q 'caelestia shell' ~/.config/hypr/hyprland.conf" "required"

print_summary
exit $?
