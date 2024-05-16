. $utils_path/features.sh

# Get the zoxide command if installed
zoxide_cmd="$(command -v zoxide)"

install() {

	# Exit if no download command is available
	if [ -z "$download_cmd" ]; then
		error "No download command available: Unable to install zoxide."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$zoxide_cmd" ]; then
		warn "zoxide is already installed."
		return 0
	fi

	# Ensure that fzf is installed
	run_feature "fzf" "install" >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		error "fzf is required to install zoxide."
		return 1
	fi

	# Install zoxide
	info "Installing zoxide..."
	
	$download_cmd https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
	code=$?

	# Add zoxide to the shell configuration
	# TODO: Add support for other shells
	echo "eval \"\$(zoxide init bash --cmd cd)\"" >> ~/.bashrc

	# Return 0 if the installation was successful
	return $code
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$zoxide_cmd" ]; then
		warn "zoxide is not installed."
		return 0
	fi

	# Uninstall zoxide
	info "Uninstalling zoxide..."

	rm -f ~/.local/bin/zoxide
	rm -f ~/.local/share/man/man1/zoxide*.1

	# TODO: Add support for other shells
	sed -i '/eval "\$(zoxide init bash --cmd cd)"/d' ~/.bashrc

	# Return 0 if the uninstallation was successful
	return 0
}