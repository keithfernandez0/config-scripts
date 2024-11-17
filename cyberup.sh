#!/bin/bash

# Ensure the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "[ :( ] Please run this script with sudo."
    exit 1
fi

# Update system and synchronize package databases
echo "[ :| ] Updating system..."
pacman -Syu --noconfirm

display_ASCII_header() {
    echo " ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  "
    echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
    echo "░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
    echo "░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  "
    echo "░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        "
    echo "░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        "
    echo " ░▒▓██████▓▒░   ░▒▓█▓▒░   ░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░        "
    echo -e "\n"
    echo -e "                  CYBER UP, v1.0, by Keith Michelangelo Fernandez, 2024                     \n\n"
    echo -e "This script automates the installation of essential tools and utilities for a fully equipped\n"
    echo -e "cybersecurity, ethical hacking, reverse engineering, and forensics workstation on Arch Linux.\n"
    echo -e "Designed with efficiency and comprehensiveness in mind, it ensures your system is ready for\n"
    echo -e "coding, penetration testing, and forensic investigations with a single execution.\n"

}

install_blackarch_keyring() {
    echo "[ :| ] Setting up BlackArch keyring..."
    curl -O https://blackarch.org/strap.sh

    echo "76363d41bd1caeb9ed2a0c984ce891c8a6075764 strap.sh" | sha1sum -c || {
        echo "[ :( ] SHA1 checksum verification failed! Exiting."
        exit 1
    }

    chmod +x strap.sh
    ./strap.sh

    echo "Enabling multilib repository..."
    sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

    echo "[ :| ] Updating package databases..."
    pacman -Syu --noconfirm

    echo "[ :3c ] BlackArch keyring setup complete!"
}

install_ethical_hacking_environment() {
    echo "[ :| ] Installing ethical hacking environment..."

    BASE_PACKAGES=(
    base-devel git wget curl unzip zip p7zip
    htop neofetch tmux zsh fzf fd ripgrep btop
    zsh-autosuggestions zsh-syntax-highlighting
    )

    DEV_TOOLS=(
        vim neovim gcc clang gdb lldb cmake make valgrind
        strace ltrace python python-pip ipython jupyter virtualenv
        jdk-openjdk maven gradle go rustup cargo nodejs npm yarn shellcheck
    )

    CYBERSEC_TOOLS=(
        metasploit nmap zenmap wireshark-qt john hashcat hydra
        sqlmap nikto openvas aircrack-ng responder impacket
    )

    REVERSE_TOOLS=(
        ghidra radare2 binwalk cutter gdb retdec bless objdump
        ndisasm capstone lsof sysdig strace hexedit
    )

    FORENSICS_TOOLS=(
        autopsy sleuthkit testdisk photorec foremost extundelete
        btrfs-progs exfat-utils volatility3 ddrescue guymager tcpdump tshark dsniff
    )

    ETHICAL_HACKING_TOOLS=(
        hashcat crunch kismet wifite reaver cowpatty mitmproxy bettercap
    )

    NETWORKING_TOOLS=(
        traceroute iperf3 netcat tcpdump openssh tmate bind dnsutils
        openvpn wireguard-tools
    )

    VIRTUALIZATION_TOOLS=(
        qemu libvirt virt-manager ovmf docker docker-compose
        virtualbox virtualbox-host-modules-arch vagrant
    )

    SECURITY_PRIVACY=(
        ufw gufw veracrypt gnupg keepassxc tor torbrowser-launcher
    )

    NOTETAKING_REPORT_TOOLS=(
        libreoffice okular zathura zathura-pdf-poppler texlive-most
        pandoc obsidian cherrytree joplin
    )

    EXTRAS=(
        ranger nnn thunar imagemagick exiftool poppler pdftk qpdf
    )

    FONTS_THEMES=(
        ttf-jetbrains-mono ttf-fira-code ttf-roboto-mono arc-gtk-theme
        papirus-icon-theme
    )

    AUR_PACKAGES=(
        gophish sleuthkit-gui mullvad-vpn sddm-lain-wired-theme
        discord_arch_electron wordlists social-engineer-toolkit
    )

    # Install packages
    pacman -S --noconfirm --needed "${ETHICAL_HACKING_TOOLS[@]}"
    pacman -S --noconfirm --needed "${BASE_PACKAGES[@]}"
    pacman -S --noconfirm --needed "${DEV_TOOLS[@]}"
    pacman -S --noconfirm --needed "${CYBERSEC_TOOLS[@]}"
    pacman -S --noconfirm --needed "${REVERSE_TOOLS[@]}"
    pacman -S --noconfirm --needed "${FORENSICS_TOOLS[@]}"
    pacman -S --noconfirm --needed "${ETHICAL_HACKING_TOOLS[@]}"
    pacman -S --noconfirm --needed "${NETWORKING_TOOLS[@]}"
    pacman -S --noconfirm --needed "${VIRTUALIZATION_TOOLS[@]}"
    pacman -S --noconfirm --needed "${SECURITY_PRIVACY[@]}"
    pacman -S --noconfirm --needed "${NOTETAKING_REPORT_TOOLS[@]}"
    pacman -S --noconfirm --needed "${EXTRAS[@]}"
    pacman -S --noconfirm --needed "${FONTS_THEMES[@]}"

    # Install AUR packages
    if ! command -v yay &>/dev/null; then
        echo "[ :| ] Installing 'yay' for AUR package management..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi

    yay -S --noconfirm "${AUR_PACKAGES[@]}"

    # Miscellaneous steps for ZSH setup
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

    echo "[ :3c ] Ethical hacking environment setup complete!"
}

# Main Menu
while true; do

    clear

    display_ASCII_header()
    echo "CyberSec Workstation Setup Script - Version 1.0.0"
    echo "-------------------------------------------------"
    echo "1. Install BlackArch keyring only"
    echo "2. Install ethical hacking environment only"
    echo "3. Install both BlackArch keyring and ethical hacking environment"
    echo "4. Exit"
    echo "-------------------------------------------------"
    read -rp "Choose an option [1-4]: " choice

    case $choice in
        1)
            install_blackarch_keyring
            break
            ;;
        2)
            install_ethical_hacking_environment
            break
            ;;
        3)
            install_blackarch_keyring
            install_ethical_hacking_environment
            break
            ;;
        4)
            echo "[ :3c ] Exiting setup. Goodbye!"
            exit 0
            ;;
        *)
            echo "[ :( ] Invalid choice. Please select a valid option."
            ;;
    esac
done
