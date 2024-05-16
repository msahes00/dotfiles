get_available() {

	# Iterate over all requirements
	for requirement in "$@"; do
			
		# Print the ones that are available
		if [ -n "$(command -v $requirement)" ]; then
			echo "$requirement"
		fi
	done
}

ensure_requirements() {

	# Iterate over all requirements
	for requirement in "$@"; do
		
		# Exit if any requirement is not available
		if [ -z "$(command -v $requirement)" ]; then
			return 1
		fi
	done

	# Return 0 if all requirements are available
	return 0
}

has_requirements() {

	# Return 1 if no requirements are available
	if [ -z "$(get_available $@)" ]; then
		return 1
	fi

	# Return 0 if any requirement are available
	return 0
}