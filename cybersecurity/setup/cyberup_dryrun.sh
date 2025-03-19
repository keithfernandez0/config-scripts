#!/bin/bash

# Ensure the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "[ :( ] Please run this script with sudo."
    exit 1
fi

check_packages() {
    for pkg in "$@"; do
        if pacman -Si "$pkg" &>/dev/null; then
            echo "Package '$pkg' exists."
        else
            echo "Package '$pkg' NOT FOUND!" >&2
        fi
    done
}

BASE_PACKAGES=(base-devel git wget curl unzip zip p7zip htop neofetch tmux zsh fzf fd ripgrep btop zsh-autosuggestions zsh-syntax-highlighting)
DEV_TOOLS=(vim neovim gcc clang gdb lldb cmake make valgrind strace ltrace python python-pip ipython jupyter virtualenv jdk-openjdk maven gradle go rustup cargo nodejs npm yarn shellcheck)
CYBERSEC_TOOLS=(metasploit nmap zenmap wireshark-qt john hashcat hydra sqlmap nikto openvas aircrack-ng responder impacket)
REVERSE_TOOLS=(ghidra radare2 binwalk cutter gdb retdec bless objdump ndisasm capstone lsof sysdig strace hexedit)
FORENSICS_TOOLS=(sleuthkit testdisk photorec foremost extundelete btrfs-progs exfat-utils volatility3 ddrescue guymager tcpdump tshark dsniff)
ETHICAL_HACKING_TOOLS=(hashcat crunch kismet wifite reaver cowpatty mitmproxy bettercap bully wifite)
NETWORKING_TOOLS=(traceroute iperf3 netcat tcpdump openssh tmate bind dnsutils openvpn wireguard-tools)
VIRTUALIZATION_TOOLS=(qemu libvirt virt-manager ovmf docker docker-compose virtualbox virtualbox-host-modules-arch vagrant)
SECURITY_PRIVACY=(ufw gufw veracrypt gnupg keepassxc tor torbrowser-launcher)
NOTETAKING_REPORT_TOOLS=(libreoffice-fresh okular zathura zathura-pdf-poppler texlive-most pandoc obsidian cherrytree joplin)
EXTRAS=(ranger nnn thunar imagemagick exiftool poppler pdftk qpdf)
FONTS_THEMES=(ttf-jetbrains-mono ttf-fira-code ttf-roboto-mono arc-gtk-theme papirus-icon-theme noto-fonts noto-fonts-emoji noto-fonts-cjk)
AUR_PACKAGES=(gophish sleuthkit-gui mullvad-vpn sddm-lain-wired-theme discord_arch_electron wordlists social-engineer-toolkit spiderfoot burpsuite recon-ng dnsprobe nuclei chrootkit autopsy gobuster)

echo "Checking pacman packages..."
check_packages "${BASE_PACKAGES[@]}" | grep "NOT FOUND"
check_packages "${DEV_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${CYBERSEC_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${REVERSE_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${FORENSICS_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${ETHICAL_HACKING_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${NETWORKING_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${VIRTUALIZATION_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${SECURITY_PRIVACY[@]}" | grep "NOT FOUND"
check_packages "${NOTETAKING_REPORT_TOOLS[@]}" | grep "NOT FOUND"
check_packages "${EXTRAS[@]}" | grep "NOT FOUND"
check_packages "${FONTS_THEMES[@]}" | grep "NOT FOUND"

echo "Checking AUR packages..."
for aur_pkg in "${AUR_PACKAGES[@]}"; do
    if yay -Si "$aur_pkg" &>/dev/null; then
        :
    else
        echo "AUR package '$aur_pkg' NOT FOUND!" >&2
    fi
done
