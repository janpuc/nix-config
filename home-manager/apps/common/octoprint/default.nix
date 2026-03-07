{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      octoprint
    ];
  };
}
