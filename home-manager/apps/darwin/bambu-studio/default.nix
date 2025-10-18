{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.bambu-studio
    ];
  };
}
