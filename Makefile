HOSTNAME := proteus
DIR := ${CURDIR}

.PHONY: darwin-init darwin home-init home home-debug update history gc fmt clean

darwin-init:
	test -f /etc/zshrc && sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
	test -f /etc/zprofile && sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
	sudo "$$(nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake .#$(HOSTNAME) 2>&1 > /dev/null | cut -d ":" -f1)" switch --flake .#$(HOSTNAME)

darwin:
	nh darwin switch .#darwinConfigurations.$(HOSTNAME)

home-init:
	nix run nixpkgs#home-manager -- switch --flake .

home:
	nh home switch .

home-debug:
	nix run nixpkgs#home-manager -- switch --flake . -L --show-trace

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
	# garbage collect all unused nix store entries
	sudo nix store gc --debug

fmt:
	# format the nix files in this repo
	nix fmt

clean:
	rm -rf result

cp:
	cp -r "$(DIR)" ~/nix-config

link:
	ln -s "$(DIR)" ~/nix-config

init-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

vm-clone:
	utmctl clone "macOS (template)" --name macOS

vm-start:
	utmctl start macOS

uninstall-bootstrap-nix:
	sudo -i nix-env --uninstall nix

set-fish:
	chsh -s /run/current-system/sw/bin/fish
