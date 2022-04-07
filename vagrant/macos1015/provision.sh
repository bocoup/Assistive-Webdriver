#!/bin/bash

set -e

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

# Automatically log in to the `vagrant` account
curl \
  --output setAutoLogin.sh \
  https://raw.githubusercontent.com/bocoup/Assistive-Webdriver/macos1015/vagrant/macos1015/setAutoLogin.sh
sudo bash setAutoLogin.sh vagrant vagrant
rm setAutoLogin.sh

# Install the Automation Voice
curl \
  --location \
  --output AutomationVoice.pkg \
  https://github.com/bocoup/Assistive-Webdriver/releases/download/macos1015/AutomationVoice.pkg
sudo installer -pkg ./AutomationVoice.pkg -target /
rm ./AutomationVoice.pkg

# Install Node.js
curl \
  --location \
  --output node-v16.14.2.pkg \
  https://nodejs.org/dist/v16.14.2/node-v16.14.2.pkg
sudo installer -pkg ./node-v16.14.2.pkg -target /
rm ./node-v16.14.2.pkg

# Optimize the size of the virtual machine image
dd if=/dev/zero of=/Users/vagrant/EMPTY bs=1m
rm /Users/vagrant/EMPTY
