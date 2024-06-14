{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      # nix
      bbenoist.nix # nix LSP
      kamadorueda.alejandra # nix linter
      # yaml
      redhat.vscode-yaml # yaml LSP
    ];

    userSettings = {
      # global
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
      # nix
      "alejandra.program" = "alejandra";
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      # misc
      "redhat.telemetry.enabled" = false;
    };
  };
}
