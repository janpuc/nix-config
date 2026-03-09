{
  config,
  hostname,
  inputs,
  lib,
  outputs,
  pkgs,
  platform,
  username,
  ...
}:
{
  imports = [
    ../../../system/darwin
  ];

  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
  };

  homebrew = {
    # masApps = {
    #   # Apps
    #   "Steam Link" = 1246969117;
    #   "Tailscale" = 1475387142;
    # };
  };
}
