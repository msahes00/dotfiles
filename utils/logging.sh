log() {
	color=$1
	prefix=$2
	text=$3

	# Skip if the message is empty
	if [ -z "$text" ]; then
		return
	fi

	# Format the message
	message="[$prefix] $text"

	# Check for color support, updating the message accordingly
	if [ -t 1 ]; then
		message="\e[1;${color}m${message}\e[0m"
	fi

	# Print the message
	if [ "$(echo -e)" != "-e" ]; then
		echo -e $message
	else
		echo $message
	fi
}

debug() {
	if [ "$debug_mode" = true ]; then
		log 36 "DEBUG" "$1"
	fi
}

info() {
	log 34 "INFO" "$1"
}

warn() {
	log 33 "WARN" "$1"
}

error() {
	log 31 "ERROR" "$1"
}

success() {
	log 32 "SUCCESS" "$1"
}