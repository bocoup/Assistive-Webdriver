#!/bin/bash

set -e

echo 'Enabling SSH...'
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

echo 'Inserting the SSH key used by Vagrant...'
mkdir -p -m 0700 /Users/vagrant/.ssh
curl \
  --output /Users/vagrant/.ssh/authorized_keys \
  https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub
chmod 0600 /Users/vagrant/.ssh/authorized_keys

echo 'Configuring `sudo` to operate without requiring a password...'
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers

echo 'Creating a group named `vagrant` (necessary for rsync-backed file sharing)...'
sudo dseditgroup -q -o create vagrant
sudo dseditgroup -o edit -a vagrant -t user vagrant

echo 'Enabling automatically login to the `vagrant` account...'
curl \
  --output setAutoLogin.sh \
  https://raw.githubusercontent.com/bocoup/Assistive-Webdriver/macos1015/vagrant/macos1015/setAutoLogin.sh
sudo bash setAutoLogin.sh vagrant vagrant
rm setAutoLogin.sh

echo 'Installing the Automation Voice...'
curl \
  --location \
  --output AutomationVoice.pkg \
  https://github.com/bocoup/Assistive-Webdriver/releases/download/macos1015/AutomationVoice.pkg
sudo installer -pkg ./AutomationVoice.pkg -target /
rm ./AutomationVoice.pkg

echo 'Installing Node.js...'
curl \
  --location \
  --output node-v16.14.2.pkg \
  https://nodejs.org/dist/v16.14.2/node-v16.14.2.pkg
sudo installer -pkg ./node-v16.14.2.pkg -target /
rm ./node-v16.14.2.pkg

echo 'Installing assistive-playwright-server...'
npm install -g assistive-playwright-server

echo 'Installing tcp-web-listener...'
npm install -g tcp-web-listener

echo 'Defining daemon for assistive-playwright-server...'
cat <<HERE | sudo tee /Library/LaunchDaemons/assistive-playwright-server.plist > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>assistive-playwright-server</string>
    <key>Program</key>
    <string>/usr/local/bin/node</string>
    <key>ProgramArguments</key>
    <array>
        <string>node</string>
        <string>/usr/local/bin/assistive-playwright-server</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>Disabled</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/var/log/assistive-playwright-server-out.txt</string>
    <key>StandardErrorPath</key>
    <string>/var/log/assistive-playwright-server-err.txt</string>
</dict>
</plist>
HERE
sudo launchctl load -w /Library/LaunchDaemons/assistive-playwright-server.plist

echo 'Disabling system sleep...'
# This first command likely subsumes those that follow, however, they are all
# executed because the available documentation does not make this claim.
sudo systemsetup -setsleep Never
sudo systemsetup -setcomputersleep Never
sudo systemsetup -setdisplaysleep Never
sudo systemsetup -setharddisksleep Never

echo 'Disabling screen saver...'
# Source: https://discussions.apple.com/thread/7610386
sudo -u vagrant defaults -currentHost write com.apple.screensaver idleTime 0

echo 'Optimizing the size of the virtual machine image...'
dd if=/dev/zero of=/Users/vagrant/EMPTY bs=1m || true
rm /Users/vagrant/EMPTY
