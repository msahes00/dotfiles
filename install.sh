#!/bin/sh

# Set some shell options (mainly for debugging)
#set -v
#set -x
set -u

# Initialize the dotfiles utility
. utils/dotfiles.sh
detect_paths "."

# Check for the required tools
. $utils_path/requirements.sh
. $utils_path/logging.sh
. $utils_path/compatibility.sh

check_minimun_requirements
if [ $? -ne 0 ]; then
    warn "Some of the required tools are missing."
    warn "Proceeding with the installation,"
    warn "although it may fail to install some features."
fi

# Load the module utility and install some features
. $utils_path/features.sh

run_feature "brew"          "install"
run_feature "docker"        "install"
run_feature "portainer"     "install"
run_feature "distrobox"     "install"
run_feature "virt-manager"  "install"
run_feature "flatpak"       "install"
run_feature "fzf"           "install"
run_feature "zoxide"        "install"
run_feature "try"           "install"
