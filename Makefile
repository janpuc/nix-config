HOSTNAME := proteus
DIR := ${CURDIR}

.PHONY: darwin-init home-init init-nix

darwin-init:
	test -f /etc/zshrc && sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
	test -f /etc/zprofile && sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
	sudo "$$(nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake .#$(HOSTNAME) 2>&1 > /dev/null | cut -d ":" -f1)" switch --flake .#$(HOSTNAME)

home-init:
	nix run nixpkgs#home-manager -- switch --flake .

init-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
