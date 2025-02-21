{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # INFO: Switch to plain VSCode before I figure out how to add cpp, copilot etc. to VSCodium
    package = pkgs.vscode;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      # nix
      bbenoist.nix # nix LSP
      kamadorueda.alejandra # nix linter
      # rust
      rust-lang.rust-analyzer
      # cpp
      # ms-vscode.cpptools
      # js
      dbaeumer.vscode-eslint
      # yaml
      redhat.vscode-yaml # yaml LSP
      # terraform
      hashicorp.terraform
      # misc
      skellock.just # justfile lint
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
