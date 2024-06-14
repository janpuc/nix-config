{user, ...}: {
  # import sub modules
  imports = [
    ./aws.nix
    ./core.nix
    ./git.nix
    ./lsd.nix
    ./oh-my-posh.nix
    ./shell.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
    ./zoxide.nix
  ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
