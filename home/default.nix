{ user, ... }:
{
  # import sub modules
  imports = [
    ./core.nix
    ./git.nix
    ./lsd.nix
    ./shell.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
  ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
