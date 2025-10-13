{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      brewCasks.proton-drive
    ];
  };
}
