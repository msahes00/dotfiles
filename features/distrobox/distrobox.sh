. $utils_path/features.sh

# Get the distrobox command if installed
distrobox_cmd="$(command -v distrobox)"

install() {

	# Exit if no download command is available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to install Distrobox."
		return 1
	fi

	# Ensure that Docker is installed
	run_feature "docker" "install" >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		error "Docker is required to install Distrobox."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$distrobox_cmd" ]; then
		warn "Distrobox is already installed."
		return 0
	fi

	# Install Distrobox
	info "Installing Distrobox..."
	
	if [ -n "$(get_user)" ]; then
		warn "Distrobox may not work properly when installed with Docker rootless."
	fi

	$download_cmd https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

	# Return 0 if the installation was successful
	return $?
}

uninstall() {

	# Exit if no download command is available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to uninstall Distrobox."
		return 1
	fi

	# Prevent uninstallation if not installed
	if [ -z "$distrobox_cmd" ]; then
		warn "Distrobox is not installed."
		return 0
	fi

	# Uninstall Distrobox
	info "Uninstalling Distrobox..."
	$download_cmd https://raw.githubusercontent.com/89luca89/distrobox/main/uninstall | sh -s -- --prefix ~/.local

	# Return 0 if the uninstallation was successful
	return $?
}