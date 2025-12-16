{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      unstable.ghostty-bin
    ];
    file."${config.home.homeDirectory}/Library/Application Support/com.mitchellh.ghostty/config" = {
      text = ''
        command = /run/current-system/sw/bin/fish
        click-repeat-interval = 500
        auto-update-channel = stable
        theme = Catppuccin Mocha
        #background-blur = macos-glass-regular
      '';
      force = true;
    };
  };
}
