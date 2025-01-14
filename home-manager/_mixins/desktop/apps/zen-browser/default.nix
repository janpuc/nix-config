{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.zen-browser
    ];
  };
}
