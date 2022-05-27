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

Next, **on the host system**, install VirtualBox Guest Additions:

1. **On the host system**, use the VirtualBox user interface to select the
   "Devices" menu, and the "Insert Guest Additions CD image..." menu item. (If
   VirtualBox reports an error for this step, then mount the CD image using
   VirtualBox's generic mechanism: shut down the virtual machine, open its
   "Settings" menu, navigate to the "Storage" tab, select the "Adds optical
   drive." button, select `VBoxGuestAdditions.iso` from the list that appears,
   and start the virtual machine again.)
2. **On the guest system**, open the disc that appears on the Desktop
3. Run the file named `VBoxDarwinAdditions.pkg`
4. Advance through the installation prompts. The installation is expected to fail.
5. Reboot the guest system.
6. Open macOS System Preferences and navigate to the "General" section of
   "Security & Privacy" General. This section should include the following
   text: "System software from developer 'Oracle America, Inc.' was blocked
   from loading." Click the associated button labeled "Allow".

(This is necessary for VirtualBox to infer the guest's virtual IP address and
expose it as a "guest property" named `/VirtualBox/GuestInfo/Net/0/V4/IP`. That
property is required by AssistiveWebdriver's automation logic.)

Finally, **on the host system**, shut down the virtual machine, rename it
`vagrant-macos-1015`, and run the following command:

    $ vagrant package --vagrantfile Vagrantfile --base vagrant-macos-1015
