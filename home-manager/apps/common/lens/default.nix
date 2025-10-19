{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      unstable.lens
    ];
  };
}
