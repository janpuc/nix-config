{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.protonvpn
    ];
  };
}
