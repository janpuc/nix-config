{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.balenaetcher
    ];
  };
}
