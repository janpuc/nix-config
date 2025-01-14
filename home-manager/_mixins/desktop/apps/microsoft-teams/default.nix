{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brewCasks.microsoft-teams
    ];
  };
}
