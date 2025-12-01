{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wireguard-ui
    ];
  };
}
