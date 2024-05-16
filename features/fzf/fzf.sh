# Get the fzf command if installed
fzf_cmd="$(command -v fzf)"

install() {

	# Exit if no git command is available
	if [ -z "$git_cmd" ]; then
		error "No git command available: Unable to install fzf."
		return 1
	fi

	# Prevent installation if already installed
	if [ -n "$fzf_cmd" ]; then
		warn "fzf is already installed."
		return 0
	fi

	# Install fzf
	info "Installing fzf..."
	
	$git_cmd clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all

	code=$?

	echo "alias cdf='cd \$(fzf)'" >> ~/.bashrc

	# Return 0 if the installation was successful
	return $code
}

uninstall() {

	# Prevent uninstallation if not installed
	if [ -z "$fzf_cmd" ]; then
		warn "fzf is not installed."
		return 0
	fi

	# Uninstall fzf
	info "Uninstalling fzf..."

	yes | ~/.fzf/uninstall
	rm -rf ~/.fzf

	# TODO: Add support for other shells
	sed -i '/alias cdf/d' ~/.bashrc

	warn "Some changes may not apply until you restart your shell."

	# Return 0 if the uninstallation was successful
	return 0
}