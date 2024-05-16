detect_paths() {

	# Get the dotfiles path relative to the main script
	containment="$1"
	if [ -z "$containment" ]; then
		containment="."
	fi

	# Resolve the absolute path of the main script
	main_path=$(readlink -f "$0")
	main_dir=$(dirname "$main_path")
	
	# Resolve the absolute path of the data directory
	dotfiles_base=$(readlink -f "$main_dir/$containment")

	# Get the paths for the features and utils directories
	features_path="$dotfiles_base/features"
	utils_path="$dotfiles_base/utils"

	# Self-modify the paths at the end of the script
	sed -i "s|^dotfiles_base=\"\"|dotfiles_base=\"$dotfiles_base\"|g" "$utils_path/dotfiles.sh"
	sed -i "s|^features_path=\"\"|features_path=\"$features_path\"|g" "$utils_path/dotfiles.sh"
	sed -i "s|^utils_path=\"\"|utils_path=\"$utils_path\"|g" "$utils_path/dotfiles.sh"	
}

# The following paths, will be updated at runtime
# dotfiles_base=""
# features_path=""
# utils_path=""

dotfiles_base=""
features_path=""
utils_path=""
