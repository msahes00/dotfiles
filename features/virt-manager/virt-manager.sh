. $utils_path/features.sh

# Get the bootstrap script path
virt_manager_cmd="$feature_path/virt-manager.sh"

install() {

	# Ensure that Distrobox is installed
	run_module "distrobox" "install" >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		error "Distrobox is required to install virt-manager."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$(cat $virt_manager_cmd)" ]; then
		warn "virt-manager is already installed."
		return 0
	fi

	# Install virt-manager
	info "Installing virt-manager..."

	distrobox create -i ubuntu:22.04 --no-entry -ap virt-manager

	distrobox enter ubuntu-22-04 -- "bash -c \"printf 'user = \\\"root\\\"\ngroup = \\\"root\\\"\nremember_owner = 0\n' | sudo tee -a /etc/libvirt/qemu.conf\""
	distrobox enter ubuntu-22-04 -- "sudo sed -i 's/\bvirbr0\b/emuvirbr0/g' /etc/libvirt/qemu/networks/default.xml"

	echo "
		#!/usr/bin/bash
		sudo kill -15 $(sudo cat /run/libvirt/network/driver.pid) 2>/dev/null
		sudo kill -15 $(sudo cat /run/libvirt/libvirtd.pid) 2>/dev/null
		sudo kill -15 $(sudo cat /run/libvirt/virtlogd.pid) 2>/dev/null
		sudo rm -rf /run/libvirt/network/driver.pid
		sudo rm -rf /var/run/libvirtd.pid
		sudo rm -rf /var/run/virtlogd.pid
		sudo libvirtd &
		sudo virtlogd &
		virt-manager
	" > $virt_manager_cmd

	chmod +x virt-manager.sh

	distrobox enter ubuntu-22-04 -- "bash virt-manager.sh"

	escaped_path=$(echo $virt_manager_cmd | sed 's/\//\\\//g')
	sed -i "s/Exec=.*/Exec=\/usr\/local\/bin\/distrobox-enter -n ubuntu-22-04 -- $escaped_path/g" .local/share/applications/ubuntu-22-04-virt-manager.desktop

	# Return 0 if the installation was successful
	return 0
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ ! -f "$virt_manager_cmd" ]; then
		warn "virt-manager is not installed."
		return 0
	fi

	# Uninstall virt-manager
	info "Uninstalling virt-manager..."
	distrobox stop -n ubuntu-22-04
	distrobox rm -n ubuntu-22-04 

	rm -f $virt_manager_cmd

	# Return 0 if the uninstallation was successful
	return $?
}