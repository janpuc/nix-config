{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.osaurus
    ];
  };
}
