{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      brewCasks.orbstack
    ];
  };
}
