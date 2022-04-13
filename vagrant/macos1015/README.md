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

    $ curl --output provision.sh https://raw.githubusercontent.com/bocoup/Assistive-Webdriver/macos1015/vagrant/macos1015/provision.sh
    $ sudo bash ./provision.sh

Then (still in the guest system) enable VoiceOver and set the text-to-speech
voice named "Cher":

1. Open the "System Preferences" application
2. Select "Accessibility"
3. Select "VoiceOver"
4. Enable the checkbox labeled "Enable VoiceOver"
5. Select "Open VoiceOver Utility..."
6. Select "Speech"
7. Open the drop-down menu for "Voice" and select "Cher"
8. Close the window named "VoiceOver Utility"
9. Close the "System Preferences" application

Next, **on the host system**, shut down the virtual machine, rename it
`vagrant-macos-1015`, and run the following command:

    $ vagrant package --base vagrant-macos-1015
