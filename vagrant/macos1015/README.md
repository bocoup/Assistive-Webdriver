# Preparing a macOS virtual machine as a Vagrant Box

This guide (and the supporting code/configuration) is a work-in-progress and
likely incomplete.

First, **on the host system**, create a macOS 10.15 ("Catalina") VirtualBox
virtual machine using the following project:

https://github.com/myspaghetti/macos-virtualbox

Next, **on the guest system**, complete the setup graphical installation guide,
providing the following information:

- full name: vagrant
- account name: vagrant
- password: vagrant

Then (still in the guest system) execute the following commands in a terminal:

    $ sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
    $ sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
    $ mkdir -m 0700 /Users/vagrant/.ssh
    $ curl https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub --output /Users/vagrant/.ssh/authorized_keys
    $ chmod 0600 /Users/vagrant/.ssh/authorized_keys
    $ dd if=/dev/zero of=/Users/vagrant/EMPTY bs=1m
    $ rm /Users/vagrant/EMPTY

    $ echo 'vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers

    $ sudo dseditgroup -o create vagrant
    $ sudo dseditgroup -o edit -a vagrant -t user vagrant

Next, **on the host system**, shut down the virtual machine, rename it
`vagrant-macos-1015`, and run the following command:

    $ vagrant package --base vagrant-macos-1015
