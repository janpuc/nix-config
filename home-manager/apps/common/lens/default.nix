{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      lens
    ];
  };
}
