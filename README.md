# dotfiles
A collection of scripts and configurations

# Included Components
* Docker
	* Portainer
* Distrobox
	* Virt-manager
* Zoxide
* Fzf
* Flatpak
* Homebrew
* Try

# Installation and Customization
To install the default components just run the install script
```sh
# Using the install script with sh
sh install.sh

# Alternatively run it standalone 
chmod +x install.sh
./install.sh
```

By default installs all components, but it can be configured to only install some of them. To do so, just edit the install script and comment/uncomment the unwanted/wanted components at the end o the file

To uninstall any of the components just change the action to uninstall like this:
```sh
run_feature "component" "install"

# Becomes
run_feature "component" "uninstall"
```