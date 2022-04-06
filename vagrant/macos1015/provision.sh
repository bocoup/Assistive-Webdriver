#!/bin/bash

# Enable SSH
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# Insert the SSH key used by Vagrant
mkdir -m 0700 /Users/vagrant/.ssh
curl \
  --output /Users/vagrant/.ssh/authorized_keys \
  https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
chmod 0600 /Users/vagrant/.ssh/authorized_keys

# Configure `sudo` to operate without requiring a password from the `vagrant
# user
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers

# Create a group named `vagrant` (necessary for rsync-backed file sharing from
# host to guest)
sudo dseditgroup -o create vagrant
sudo dseditgroup -o edit -a vagrant -t user vagrant

# Optimize the size of the virtual machine image
dd if=/dev/zero of=/Users/vagrant/EMPTY bs=1m
rm /Users/vagrant/EMPTY

# Automatically log in to the `vagrant` account
curl \
  --output setAutoLogin.sh \
  https://raw.githubusercontent.com/bocoup/macAdminTools/main/Scripts/setAutoLogin.sh
sudo bash setAutoLogin.sh vagrant vagrant

# Install the Automation Voice
curl \
  --location \
  --output AutomationVoice.pkg \
  https://github.com/bocoup/Assistive-Webdriver/releases/download/macos1015/AutomationVoice.pkg
sudo installer -pkg ./AutomationVoice.pkg -target /
