{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.cursor
    ];
  };
}
