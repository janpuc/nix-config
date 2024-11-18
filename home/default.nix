{user, ...}: {
  # import sub modules
  imports = [
    ./aws.nix
    ./core.nix
    ./git.nix
    ./js.nix
    ./lsd.nix
    ./oh-my-posh.nix
    ./op.nix
    ./shell.nix
    ./ssh.nix
    ./vscode.nix
    ./zoxide.nix
  ];

  home = {
    username = user.name;
    homeDirectory = "/Users/${user.name}";

    preferXdgDirectories = true;

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
