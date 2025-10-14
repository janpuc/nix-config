{pkgs, ...}: let
  macApps = {
    "Steam Link" = "1246969117";
    "AdGuard for Safari" = "1440147259";
  };

  macAppIDs = builtins.attrValues macApps;
in {
  home = {
    packages = with pkgs; [
      mas
    ];

    activation = {
      installMacApps = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
        installed_ids=$(mas list | awk '{print $1}')
        for id in ${builtins.concatStringsSep " " macAppIDs}; do
          if ! echo "''${installed_ids}" | grep -q "^''${id}$"; then
            echo "Installing App Store app ''${id}..."
            mas install "''${id}"
          else
            echo "App Store app ''${id} is already installed."
          fi
        done
      '';
    };
  };
}
