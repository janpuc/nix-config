# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  bambu-studio = pkgs.callPackage ./bambu-studio {};
  beeper = pkgs.callPackage ./beeper {};
  microsoft-teams = pkgs.callPackage ./microsoft-teams {};
  orbstack = pkgs.callPackage ./orbstack {};
  # proton-drive = pkgs.callPackage ./proton-drive {};
}
