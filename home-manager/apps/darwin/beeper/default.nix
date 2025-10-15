{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      brewCasks.beeper
    ];
  };
}
