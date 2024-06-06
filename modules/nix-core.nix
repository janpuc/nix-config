{
  pkgs,
  lib,
  ...
}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community-cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;

  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nix.settings = {
    auto-optimise-store = false;
  };
}
