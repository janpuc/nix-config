{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.obsidian
    ];
  };
}
