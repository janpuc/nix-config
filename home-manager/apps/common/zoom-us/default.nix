{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      unstable.zoom-us
    ];
  };
}
