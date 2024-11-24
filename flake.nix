{
  description = "Nix for macOS configuration";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2405.*";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0";

    _1password-shell-plugins.url = "github:1Password/shell-plugins";
    _1password-shell-plugins.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # FlakeHub
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
    catppuccin-vsc.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0";

    # TODO: to replace with https://github.com/BatteredBunny/brew-nix
    # nix-homebrew = {
    #   url = "github:zhaofengli-wip/nix-homebrew";
    # };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
  };
  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
    helper = import ./lib {inherit inputs outputs stateVersion;};
  in {
    # home-manager switch -b backup --flake $HOME/nix-config
    # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/nix-config"
    homeConfigurations = {
      "jan.pucilowski@hashirama" = helper.mkHome {
        hostname = "hashirama";
      };
    };
    # nix run nix-darwin -- switch --flake ~/nix-config
    # nix build .#darwinConfigurations.{hostname}.config.system.build.toplevel
    darwinConfigurations = {
      hashirama = helper.mkDarwin {hostname = "hashirama";};
    };
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for .nix files, accessible via 'nix fmt'
    formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };

  # outputs = inputs @ {
  #   self,
  #   nixpkgs,
  #   darwin,
  #   nix-homebrew,
  #   homebrew-bundle,
  #   homebrew-core,
  #   homebrew-cask,
  #   home-manager,
  #   ...
  # }: let
  #   user = {
  #     name = "jan.pucilowski";
  #     github = "janpuc";
  #     email = "janpuc@proton.me";
  #   };
  #   system = "aarch64-darwin";
  #   hostname = "janpuc-mbp";
  #   specialArgs = {
  #     inherit inputs user hostname;
  #   };
  # in {
  #   darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
  #     inherit system specialArgs;
  #     # extraSpecialArgs = {
  #     #   inherit inputs;
  #     # };
  #     modules = [
  #       ./darwin/bootstrap.nix
  #       ./darwin/general.nix

  #       ./modules/nix-core.nix
  #       ./modules/system.nix
  #       ./modules/apps.nix
  #       ./modules/dock.nix
  #       ./modules/host-users.nix

  #       home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.extraSpecialArgs = specialArgs;
  #         home-manager.users.${user.name} = import ./home;
  #       }
  #       nix-homebrew.darwinModules.nix-homebrew
  #       {
  #         nix-homebrew = {
  #           user = user.name;
  #           enable = true;
  #           taps = {
  #             "homebrew/homebrew-core" = homebrew-core;
  #             "homebrew/homebrew-cask" = homebrew-cask;
  #             "homebrew/homebrew-bundle" = homebrew-bundle;
  #           };
  #           mutableTaps = false;
  #           autoMigrate = true;
  #         };
  #       }
  #     ];
  #   };
  #   formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  # };
}
