{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      brewCasks.whisky
    ];
  };
}
