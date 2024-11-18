HOSTNAME := janpuc-mbp

.PHONY: darwin darwin-debug update history gc fmt clean

darwin:
	nix build .#darwinConfigurations.$(HOSTNAME).system \
	  --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)

darwin-debug:
	nix build .#darwinConfigurations.$(HOSTNAME).system --show-trace --verbose \
	  --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME) --show-trace --verbose

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

link:
	ln "$(pwd)" ~/nix-config

init-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

vm-clone:
	utmctl clone "macOS (template)" --name macOS

vm-start:
	utmctl start macOS
