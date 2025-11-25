{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      unstable.discord
    ];
  };
}
