# { pkgs, ... }:
# {
#   # Networking
#   networking.dns = [
#     "1.1.1.1"
#     "8.8.8.8"
#   ];

#   # Fonts
#   fonts.packages = with pkgs; [
#     recursive
#     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
#   ];

#   # Keyboard
#   system.keyboard.enableKeyMapping = true;
#   system.keyboard.remapCapsLockToEscape = false;

#   # Add ability to use TouchID for sudo
#   security.pam.enableSudoTouchIdAuth = true;

#   # Store management
#   nix.gc.automatic = true;
#   nix.gc.interval.Hour = 3;
#   nix.gc.options = "--delete-older-than 15d";
#   nix.optimise.automatic = true;
#   nix.optimise.interval.Hour = 4;
# }
