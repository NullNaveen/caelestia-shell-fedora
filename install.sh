#!/bin/bash
# Caelestia Shell Installer for Fedora 43
# This script automates the entire build and installation process

set -e  # Exit on error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_fedora_version() {
    print_step "Checking Fedora version..."
    if ! grep -q "Fedora release 43" /etc/fedora-release 2>/dev/null; then
        print_warning "This script was designed for Fedora 43. Your version may work but is untested."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

install_build_dependencies() {
    print_header "Installing Build Dependencies"
    
    sudo dnf install -y \
        cmake ninja-build gcc-c++ \
        qt6-qtbase-devel qt6-qtbase-private-devel \
        qt6-qtdeclarative-devel qt6-qtshadertools-devel \
        qt6-qtwayland-devel qt6-qttools-devel qt6-qtsvg-devel \
        wayland-devel wayland-protocols-devel \
        libdrm-devel mesa-libgbm-devel pipewire-devel \
        pkgconf-pkg-config jemalloc-devel cli11-devel \
        polkit-devel pam-devel fftw-devel aubio-devel \
        libqalculate-devel git unzip curl
}

install_runtime_dependencies() {
    print_header "Installing Runtime Dependencies"
    
    sudo dnf install -y \
        swappy ddcutil brightnessctl wl-clipboard \
        lm_sensors NetworkManager fish libqalculate
}

build_quickshell() {
    print_header "Building Quickshell"
    
    if [ -d ~/Projects/quickshell ]; then
        print_warning "Quickshell directory exists. Updating..."
        cd ~/Projects/quickshell
        git pull
    else
        git clone https://git.outfoxxed.me/outfoxxed/quickshell.git ~/Projects/quickshell
        cd ~/Projects/quickshell
    fi
    
    cmake -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DBUILD_TESTING=OFF \
        -DCRASH_REPORTER=OFF
    
    cmake --build build -j$(nproc)
    sudo cmake --install build
}

build_libcavacore() {
    print_header "Building libcavacore"
    
    if [ -d ~/Projects/cava ]; then
        print_warning "Cava directory exists. Updating..."
        cd ~/Projects/cava
        git pull
    else
        git clone https://github.com/karlstav/cava.git ~/Projects/cava
        cd ~/Projects/cava
    fi
    
    git checkout 0.10.2
    
    cmake -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    
    cmake --build build -j$(nproc)
    sudo cmake --install build
    
    # Create pkg-config file
    sudo tee /usr/lib64/pkgconfig/cava.pc > /dev/null << 'EOF'
prefix=/usr/local
exec_prefix=${prefix}
libdir=${prefix}/lib
includedir=${prefix}/include/cava

Name: cava
Description: Console-based Audio Visualizer for ALSA
Version: 0.10.2
Libs: -L${libdir} -lcavacore -lm -lfftw3
Cflags: -I${includedir}
EOF
}

build_caelestia_modules() {
    print_header "Building Caelestia QML Modules"
    
    if [ -d ~/Projects/caelestia-shell ]; then
        print_warning "Caelestia directory exists. Updating..."
        cd ~/Projects/caelestia-shell
        git pull
    else
        git clone https://github.com/caelestia-dots/shell.git ~/Projects/caelestia-shell
        cd ~/Projects/caelestia-shell
    fi
    
    # Build each module
    for module in Caelestia Caelestia/Internal Caelestia/Models Caelestia/Services; do
        print_step "Building $module..."
        cd "modules/$module"
        
        qmake6 PREFIX=/usr/local
        make -j$(nproc)
        sudo make install
        
        cd ~/Projects/caelestia-shell
    done
}

install_hyprland() {
    print_header "Installing Hyprland"
    
    if ! dnf repolist | grep -q "copr:copr.fedorainfracloud.org:solopasha:hyprland"; then
        print_step "Enabling Hyprland COPR repository..."
        sudo dnf copr enable solopasha/hyprland -y
    fi
    
    sudo dnf install -y hyprland hyprland-uwsm xdg-desktop-portal-hyprland \
        hyprpaper hypridle hyprlock
}

install_fonts() {
    print_header "Installing Required Fonts"
    
    mkdir -p ~/.local/share/fonts
    cd /tmp
    
    # Cascadia Code Nerd Font
    print_step "Installing Cascadia Code Nerd Font..."
    curl -L -o CascadiaCode.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
    unzip -o CascadiaCode.zip -d ~/.local/share/fonts/CaskaydiaCove
    
    # Material Symbols Rounded
    print_step "Installing Material Symbols..."
    curl -L -o MaterialSymbolsRounded.ttf \
        "https://github.com/google/material-design-icons/raw/master/font/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf"
    install -Dm644 MaterialSymbolsRounded.ttf \
        ~/.local/share/fonts/MaterialSymbols/MaterialSymbolsRounded.ttf
    
    # Rubik
    print_step "Installing Rubik font..."
    curl -L -o Rubik.ttf \
        https://github.com/google/fonts/raw/main/ofl/rubik/Rubik%5Bwght%5D.ttf
    install -Dm644 Rubik.ttf ~/.local/share/fonts/Rubik/Rubik.ttf
    
    # Refresh font cache
    fc-cache -f ~/.local/share/fonts
}

install_caelestia_cli() {
    print_header "Installing Caelestia CLI"
    
    python3 -m pip install --user build installer hatch hatch-vcs
    
    if [ -d ~/Projects/caelestia-cli ]; then
        print_warning "Caelestia CLI directory exists. Updating..."
        cd ~/Projects/caelestia-cli
        git pull
    else
        git clone https://github.com/caelestia-dots/cli.git ~/Projects/caelestia-cli
        cd ~/Projects/caelestia-cli
    fi
    
    python3 -m build --wheel
    sudo python3 -m pip install dist/*.whl --force-reinstall
}

configure_environment() {
    print_header "Configuring Environment"
    
    # Set QML import path
    print_step "Setting QML import path..."
    mkdir -p ~/.config/environment.d
    cat << 'EOF' > ~/.config/environment.d/50-caelestia.conf
QML2_IMPORT_PATH=/usr/local/lib64/qt6/qml:$QML2_IMPORT_PATH
EOF
    
    # Configure Hyprland
    print_step "Configuring Hyprland..."
    mkdir -p ~/.config/hypr
    
    if [ ! -f ~/.config/hypr/hyprland.conf ]; then
        cp /usr/share/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
    fi
    
    # Add Caelestia autostart if not already present
    if ! grep -q "caelestia shell" ~/.config/hypr/hyprland.conf; then
        cat << 'EOF' >> ~/.config/hypr/hyprland.conf

# Caelestia Shell
exec-once = caelestia shell -d
EOF
    fi
    
    # Copy Caelestia shell configuration
    print_step "Installing Caelestia shell files..."
    mkdir -p ~/.config/quickshell
    if [ -d ~/Projects/caelestia-shell ]; then
        cp -r ~/Projects/caelestia-shell/* ~/.config/quickshell/caelestia/
    fi
}

print_completion() {
    print_header "Installation Complete!"
    
    echo -e "${GREEN}Caelestia shell has been successfully installed!${NC}\n"
    echo -e "Next steps:"
    echo -e "  1. ${YELLOW}Log out${NC} from your current desktop session"
    echo -e "  2. At the login screen, ${YELLOW}click the gear icon${NC} (⚙️)"
    echo -e "  3. Select ${YELLOW}\"Hyprland\"${NC} from the session list"
    echo -e "  4. Log in — Caelestia will start automatically\n"
    echo -e "New to Hyprland? Read the guide:"
    echo -e "  ${BLUE}cat ~/Projects/caelestia-shell-fedora/HYPRLAND_GUIDE.md${NC}\n"
    echo -e "Test in current session (limited functionality):"
    echo -e "  ${BLUE}~/Projects/caelestia-shell-fedora/test-in-hyprland.sh${NC}\n"
}

# Main execution
main() {
    print_header "Caelestia Shell Installer for Fedora 43"
    
    check_fedora_version
    install_build_dependencies
    install_runtime_dependencies
    build_quickshell
    build_libcavacore
    build_caelestia_modules
    install_hyprland
    install_fonts
    install_caelestia_cli
    configure_environment
    print_completion
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
