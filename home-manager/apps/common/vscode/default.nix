{
  hostname,
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # INFO: Switch to plain VSCode before I figure out how to add cpp, copilot etc. to VSCodium
    package = pkgs.unstable.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        # nix
        jnoortheen.nix-ide
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
        # opentofu.vscode-opentofu
        # misc
        skellock.just # justfile lint
      ];

      keybindings = [
        # Remapping eeded for MacOS window management shortcuts

        # Remove existing bindings
        {
          key = "ctrl+alt+left";
          command = "-cursorWordPartLeft";
        }
        {
          key = "ctrl+alt+right";
          command = "-cursorWordPartRight";
        }
        # Add remapped ones
        {
          key = "ctrl+shift+alt+cmd+left";
          command = "cursorWordPartLeft";
          when = "textInputFocus";
        }
        {
          key = "ctrl+shift+alt+cmd+right";
          command = "cursorWordPartRight";
          when = "textInputFocus";
        }
      ];

      userSettings = {
        # global
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
        # nix
        "[nix]" = {
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "nixd";
          "serverSettings.nixd" = {
            "formatting.command" = [ "nixfmt" ];
            "options" = {
              "home-manager.expr" =
                "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.${hostname}.options";
              "nix-darwin.expr" =
                "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.${hostname}.options";
            };
          };
        };
        # misc
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
