#!/bin/bash

# =======================================================================
# Adaptation of commenter fallen1011 and their advice that worked for me.
# See Arch Wiki thread: https://bbs.archlinux.org/viewtopic.php?id=146339
# ALSA and Corsair Headset [SOLVED] - 2012-08-03 03:58:02
# =======================================================================

# Install necessary packages
echo "Installing required packages..."
sudo pacman -S --noconfirm alsa-utils alsa-oss alsa-plugins pulseaudio pavucontrol ib32-alsa-plugins lib32-libpulse pulseaudio-alsa

# Add groups for PulseAudio access and real-time privileges
echo "Creating PulseAudio groups..."
sudo groupadd pulse-access
sudo groupadd pulse-rt

# Add the current user to the PulseAudio groups
echo "Adding user to pulse-access and pulse-rt groups..."
sudo gpasswd -a "$USER" pulse-access
sudo gpasswd -a "$USER" pulse-rt

# Set up ALSA configuration file
echo "Setting up /etc/asound.conf..."
echo -e "pcm.pulse {\n    type pulse\n}\nctl.pulse {\n    type pulse\n}\npcm.!default {\n    type pulse\n}\nctl.!default {\n    type pulse\n}" | sudo tee /etc/asound.conf > /dev/null

# Set up libao configuration file
echo "Setting up /etc/libao.conf..."
echo "default_driver=pulse" | sudo tee /etc/libao.conf > /dev/null

# Prompt the user to load pavucontrol and switch to the desired device
echo "Installation and setup complete."
echo "Now, load pavucontrol and select your desired audio device."
echo "If you are using a web browser, play a video first for the device to show up."
