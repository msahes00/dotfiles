# Get the docker command if installed
docker_cmd="$(command -v docker)"

install() {

	# Exit if no download command is available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to install Docker."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$docker_cmd" ]; then
		warn "Docker is already installed."
		return 0
	fi


	# Perform the actual installation
	info "Installing Docker..."

	# Prepare the command to install docker
	if [ -z "$(get_user)" ]; then
		install_cmd="$download_cmd https://get.docker.com | $root_cmd sh"
	else
		warn "Installing rootless Docker."
		warn "Rootless Docker is not recommended."
		install_cmd="$download_cmd https://get.docker.com/rootless | sh"
	fi

	# Perform the installation
	$install_cmd

	# Return 0 if the installation was successful
	return $?
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$docker_cmd" ]; then
		warn "Docker is not installed."
		return 0
	fi

	# Perform the actual uninstallation
	info "Uninstalling Docker..."

	# Uninstall Docker rootless
	if [ -z "$(get_user)" ]; then

		# TODO: verify cross-platform compatibility
		$root_cmd $uninstall_cmd docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
		$root_cmd rm -rf /var/lib/docker
		$root_cmd rm -rf /var/lib/containerd
	else

		rm -rf ~/.local/share/docker
		rm -rf ~/.docker
		rm -rf ~/bin
	fi

	# Return 0 if the uninstallation was successful
	return $?
}