#!/usr/bin/env bash
# Repository/zypp.sh — Zypper repository definitions (openSUSE Tumbleweed)
set -euo pipefail

# ----------------------------------------------------------------
# Repository addition functions
# ----------------------------------------------------------------

repo_nvidia_zypp() {
	sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l openSUSE-repos-Tumbleweed-NVIDIA
	sudo zypper --gpg-auto-import-keys ar -n "Cuda (OpenSUSE 15)" -cfp 91 \
		"https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/cuda-opensuse15.repo" || true
}

repo_packman_zypp() {
	sudo zypper --gpg-auto-import-keys ar -n "Packman Essentials" -cfp 90 \
		"https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/" packman-essentials || true
	sudo zypper --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
}

repo_snapd_zypp() {
	sudo zypper --gpg-auto-import-keys addrepo -n "Snappy" \
		"https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed" snappy || true
}

repo_asuscommunity_zypp() {
	sudo rpm --import https://download.copr.fedorainfracloud.org/results/lukenukem/asus-linux/pubkey.gpg
	sudo zypper --gpg-auto-import-keys ar -p 50 -n "Asus Linux (OpenSUSE Tumbleweed)" \
		-r "https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/opensuse-tumbleweed/lukenukem-asus-linux-opensuse-tumbleweed.repo" asus-linux || true
}

repo_bravebrowser_zypp() {
	sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l curl
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo zypper --gpg-auto-import-keys addrepo -n "Brave Browser" \
		-f "https://brave-browser-rpm-release.s3.brave.com/x86_64/" brave-browser || true
}

repo_chrome_zypp() {
	sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
	sudo zypper --gpg-auto-import-keys addrepo -n "Google Chrome" \
		"http://dl.google.com/linux/chrome/rpm/stable/x86_64" Google-Chrome || true
}

repo_edge_zypp() {
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo zypper --gpg-auto-import-keys addrepo -n "Microsoft Edge" \
		"https://packages.microsoft.com/yumrepos/edge" microsoft-edge || true
}

repo_anydesk_zypp() {
	sudo rpm --import https://keys.anydesk.com/repos/RPM-GPG-KEY
	sudo zypper --gpg-auto-import-keys addrepo -n "AnyDesk OpenSUSE - stable" \
		-f "http://rpm.anydesk.com/opensuse/\$basearch/" anydesk || true
}

repo_teamviewer_zypp() {
	sudo rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc
	sudo zypper --gpg-auto-import-keys addrepo --gpgcheck -n "TeamViewer - \$basearch" \
		"https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/" teamviewer || true
}

repo_microsoft_zypp() {
	sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l libicu krb5
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	wget -q https://packages.microsoft.com/config/opensuse/16/prod.repo
	sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
	sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
}

repo_cloudflarewarp_zypp() {
	sudo rpm --import https://pkg.cloudflareclient.com/pubkey.gpg
	curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo \
		| sudo tee /etc/zypp/repos.d/cloudflare-warp.repo >/dev/null
}

repo_vscode_zypp() {
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	cat <<-'REPO' | sudo tee /etc/zypp/repos.d/vscode.repo >/dev/null
		[code]
		name=Visual Studio Code
		baseurl=https://packages.microsoft.com/yumrepos/vscode
		enabled=1
		type=rpm-md
		gpgcheck=1
		gpgkey=https://packages.microsoft.com/keys/microsoft.asc
	REPO
}

repo_sublimetexteditor_zypp() {
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo zypper --gpg-auto-import-keys --no-gpg-checks addrepo -g -f "https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo" || true
}

repo_megasync_zypp() {
	sudo rpm --import https://mega.nz/linux/repo/openSUSE_Tumbleweed/repodata/repomd.xml.key
	sudo zypper --gpg-auto-import-keys addrepo -n "MEGAsync" \
		"https://mega.nz/linux/repo/openSUSE_Tumbleweed/" MEGAsync || true
}

# ----------------------------------------------------------------
# Add repositories
# ----------------------------------------------------------------
sudo zypper --gpg-auto-import-keys refresh

repo_nvidia_zypp
repo_asuscommunity_zypp

repo_packman_zypp
repo_snapd_zypp

repo_bravebrowser_zypp
repo_chrome_zypp
repo_edge_zypp

repo_anydesk_zypp
repo_teamviewer_zypp
repo_cloudflarewarp_zypp

repo_microsoft_zypp

repo_vscode_zypp
repo_sublimetexteditor_zypp

repo_megasync_zypp
