# IMPORTANT: this is a file designed to be sourced AFTER the dotfiles.sh file

run_feature() {

	# Store some information
	feature=$1
	operation=$2

	# Get the feature path and main script
	feature_path="$features_path/$feature"
	feature_script="$feature_path/$feature.sh"

	# Perform some sanity checks
	if [ ! -d "$dotfiles_base" ]; then
		return 1
	elif [ ! -d "$feature_path" ]; then
		return 2
	elif [ ! -f "$feature_script" ]; then
		return 3
	fi

	# Inject builtins, source the script and run the requested operation
	eval "
		. $utils_path/dotfiles.sh
		. $utils_path/builtins.sh
		feature_path=\"$feature_path\"
		feature_script=\"$feature_script\"

		. $feature_script

		$operation
		return $?
	"
	return $?
}