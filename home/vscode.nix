{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
    ];

    userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
    };
  };
}
