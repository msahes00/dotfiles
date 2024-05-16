# Get the try command if installed
try_cmd="$(command -v try)"

install() {

	# Exit if no git command is available
	if [ -z "$git_cmd" ]; then
		error "No git command available: Unable to install try."
		return 1
	fi

	# Exit if the download command is not available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to install try."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$try_cmd" ]; then
		warn "try is already installed."
		return 0
	fi

	# Install try
	info "Installing try..."

	# Install mergefs
	mkdir -p ~/.mergefs
	$download_cmd https://github.com/trapexit/mergerfs/releases/latest/download/mergerfs-static-linux_amd64.tar.gz | tar -xz --strip-components=2 -C ~/.mergefs
	ln -s ~/.mergefs/bin/mergerfs ~/.local/bin/mergerfs
	
	$git_cmd clone https://github.com/binpash/try.git ~/.try
	ln -s ~/.try/try ~/.local/bin/try

	# Return 0 if the installation was successful
	return $?
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$try_cmd" ]; then
		warn "try is not installed."
		return 0
	fi

	# Uninstall try
	info "Uninstalling try..."

	# Uninstall try
	rm -rf ~/.try
	rm -f ~/.local/bin/try

	# Uninstall mergefs
	rm -rf ~/.mergefs
	rm -f ~/.local/bin/mergerfs

	# Return 0 if the uninstallation was successful
	return $?
}