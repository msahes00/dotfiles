flatpak_cmd="$(command -v flatpak)"

install() {

	# Exit if no install command is available
	if [ -z "$install_cmd" ]; then
		error "No install command available: Unable to install Flatpak."
		return 1
	fi

	# Check if Flatpak is already installed
	if [ -n "$flatpak_cmd" ]; then
		warn "Flatpak is already installed."
	else
		# Install flatpak
		info "Installing Flatpak..."
		$root_cmd $install_cmd flatpak

		# Get the flatpak command
		flatpak_cmd="$(command -v flatpak)"
	fi


	# Add each repository, filtering out comments
	cat "$(readlink -f $feature_path/repo.list)" | sed 's/#.*//' | while read -r line; do
		
		# Ignore commented lines
		if [ -z "$line" ]; then
			continue
		fi

		info "Adding repository '$line'..."	
		$flatpak_cmd remote-add --if-not-exists --user $line
	
	done

	# Install each app from the list, filtering out comments
	cat "$(readlink -f $feature_path/apps.list)" | sed 's/#.*//' | while read -r line; do
		
		# Ignore commented lines
		if [ -z "$line" ]; then
			continue
		fi

		info "Installing app '$line'..."
		$flatpak_cmd install --user -y $line

	done

	return 0
}

uninstall() {

	# Exit if no uninstall command is available
	if [ -z "$uninstall_cmd" ]; then
		error "No uninstall command available."
		return 1
	fi

	# Check if Flatpak is already installed
	if [ -z "$flatpak_cmd" ]; then
		warn "Flatpak is already uninstalled."
		return 0
	fi


	# Uninstall each app from the list, filtering out comments
	cat "$(readlink -f $feature_path/apps.list)" | sed 's/#.*//' | while read -r line; do
		
		# Ignore commented lines
		if [ -z "$line" ]; then
			continue
		fi

		echo $line

		# Get the app name and ignore the repository
		line=$(echo $line | cut -d ' ' -f 2)

		echo $line

		info "Uninstalling app '$line'..."
		$flatpak_cmd uninstall --user -y $line

	done

	# Uninstall any leftover runtime
	info "Uninstalling leftover runtimes..."
	$flatpak_cmd uninstall --user -y --unused

	# Remove each repository, filtering out comments
	cat "$(readlink -f $feature_path/repo.list)" | sed 's/#.*//' | while read -r line; do
		
		# Ignore commented lines
		if [ -z "$line" ]; then
			continue
		fi

		line=$(echo $line | cut -d ' ' -f 1)
		info "Removing repository '$line'..."
		$flatpak_cmd remote-delete --user $line
	done

	# Uninstall flatpak
	info "Uninstalling Flatpak..."
	$root_cmd $uninstall_cmd flatpak
	code=$?

	# Remove flatpak leftover stuff
	rm -rf ~/.local/share/flatpak

	return $code
}