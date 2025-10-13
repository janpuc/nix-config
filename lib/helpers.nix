{
  inputs,
  outputs,
  stateVersion,
  ...
}: {
  # Helper function for generating home-manager configs
  mkHome = {
    hostname,
    username ? "jan.pucilowski",
    desktop ? null,
    platform ? "aarch64-darwin",
  }: let
    isInstall = true;
    isLaptop = true;
    isWorkstation = builtins.isString desktop;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isLaptop
          isWorkstation
          ;
      };
      modules = [../home-manager];
    };

  mkDarwin = {
    desktop ? "aqua",
    hostname,
    username ? "jan.pucilowski",
    platform ? "aarch64-darwin",
  }: let
    isInstall = true;
    isLaptop = true;
    isWorkstation = true;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isLaptop
          isWorkstation
          ;
      };
      modules = [../darwin];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
