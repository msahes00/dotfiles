# IMPORTANT: this is a file designed to be sourced AFTER the dotfiles.sh file
. $utils_path/requirements.sh

get_distro() {
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo $ID
	elif [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
		echo $DISTRIB_ID
	elif [ -f /etc/debian_version ]; then
		echo "debian"
	elif [ -f /etc/arch-release ]; then
		echo "arch"
	elif [ -f /etc/redhat-release ]; then
		echo "redhat"
	elif [ -f /etc/gentoo-release ]; then
		echo "gentoo"
	elif [ -f /etc/SuSE-release ]; then
		echo "suse"
	else
		echo ""
	fi
}

get_download_cmd() {
	get_available 'curl -fsSL' 'wget -qO-' | head -n 1
}

get_install_cmd() {
	get_available 'apt-get install -y' 'dnf install -y' 'yum install -y' 'zypper install -y' 'pacman -S --noconfirm' 'emerge --ask' 'apk add' 'brew install' | head -n 1
}

get_uninstall_cmd() {
	get_available 'apt-get autoremove -y' 'dnf remove -y' 'yum remove -y' 'zypper remove -y' 'pacman -Rns' 'emerge --unmerge' 'apk del' 'brew uninstall' | head -n 1
}

get_git_cmd() {
	get_available 'git' 'git-core' | head -n 1
}

get_root_cmd() {
	get_available 'sudo' 'doas' 'su -c' | head -n 1
}

get_user() {
	echo $(id -u)
}


get_all_cmd() {
	download_cmd=$(get_download_cmd)
	install_cmd=$(get_install_cmd)
	uninstall_cmd=$(get_uninstall_cmd)
	git_cmd=$(get_git_cmd)
}

check_minimun_requirements() {
	get_all_cmd

	ensure_requirements "$download_cmd" "$install_cmd" "$uninstall_cmd" "$git_cmd"

	return $?
}