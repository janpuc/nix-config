{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      unstable.raycast
    ];
  };
}
