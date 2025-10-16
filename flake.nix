{
  description = "Nix for macOS configuration";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2505.*";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0";

    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";

    brew-api.url = "github:BatteredBunny/brew-api";
    brew-api.flake = false;

    brew-nix.url = "github:BatteredBunny/brew-nix";
    brew-nix.inputs.brew-api.follows = "brew-api";

    catppuccin.url = "github:catppuccin/nix/release-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # FlakeHub
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
    catppuccin-vsc.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0";
  };
  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    brew-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
    helper = import ./lib {inherit inputs outputs stateVersion;};
  in {
    # home-manager switch -b backup --flake $HOME/nix-config
    # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/nix-config"
    homeConfigurations = {
      "jan.pucilowski@hermes" = helper.mkHome {
        hostname = "hermes";
        platform = "aarch64-darwin";
      };
      "jan.pucilowski@proteus" = helper.mkHome {
        hostname = "proteus";
        platform = "aarch64-darwin";
      };
    };
    # nix run nix-darwin -- switch --flake ~/nix-config
    # nix build .#darwinConfigurations.{hostname}.config.system.build.toplevel
    darwinConfigurations = {
      hashirama = helper.mkDarwin {hostname = "hermes";};
      proteus = helper.mkDarwin {hostname = "proteus";};
    };
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for .nix files, accessible via 'nix fmt'
    formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };
}
