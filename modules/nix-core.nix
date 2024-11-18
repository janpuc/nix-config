{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;
}
