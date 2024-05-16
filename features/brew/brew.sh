brew_cmd=$(command -v brew)

install() {

	# Exit if no download command is available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to install Homebrew."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$brew_cmd" ]; then
		warn "Homebrew is already installed."
		return 0
	fi

	# Install Homebrew
	info "Installing Homebrew..."

	$download_cmd https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | $(which bash)

	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc


	# Return 0 if the installation was successful
	return $?
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$brew_cmd" ]; then
		warn "Homebrew is not installed."
		return 0
	fi

	# Uninstall Homebrew
	info "Uninstalling Homebrew..."

	$download_cmd https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh | $(which bash)
	sed -i '/eval "\$($(brew --prefix)\/bin\/brew shellenv)"/d' ~/.bashrc
	
	# Return 0 if the uninstallation was successful
	return $?
}