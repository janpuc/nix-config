{
  hostname,
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = 5;

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  environment = {
    shells = [ pkgs.fish ];
    systemPackages = with pkgs; [
      git
      m-cli
      mas
      nix-output-monitor
      nvd
      plistwatch
      sops
    ];

    variables = {
      EDITOR = "nano";
      SYSTEMD_EDITOR = "nano";
      VISUAL = "nano";
    };
  };

  nix.enable = false; # Needed for new Nix Determinate default comming in 1st of January

  networking.hostName = hostname;
  networking.computerName = hostname;
}
