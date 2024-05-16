. $utils_path/features.sh

install() {
	
	# Check if Docker is installed
	run_module "docker" "install" >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		error "No docker command available: Unable to install Portainer."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$(docker ps -a --format '{{.Names}}' | grep portainer)" ]; then
		warn "Portainer is already installed."
		return 0
	fi

	# Install Portainer
	info "Installing Portainer..."

	# Update the docker socket path if rootless
	docker_socket="/var/run/docker.sock"
	if [ -n "$(get_user)" ]; then
		warn "Installing Portainer with Docker rootless."
		docker_socket="/run/user/$(get_user)/docker.sock"
	fi

	$root_cmd docker volume create portainer_data
	$root_cmd docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

	# Return 0 if the installation was successful
	return $?
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$(docker ps -a --format '{{.Names}}' | grep portainer)" ]; then
		warn "Portainer is not installed."
		return 0
	fi

	# Uninstall Portainer
	info "Uninstalling Portainer..."
	$root_cmd docker rm -f portainer
	$root_cmd docker volume rm portainer_data

	# Return 0 if the uninstallation was successful
	return $?
}