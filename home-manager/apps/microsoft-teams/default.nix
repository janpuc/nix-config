{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      microsoft-teams
    ];
  };
}
