{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password
    alejandra
    bat # modern replacement for cat

    # Apps
    rectangle

    # arc-browser  # TODO: enable when it's fixed
    # messenger  # TODO: can't find it
    # teams  # TODO: only old teams available
    slack
    wezterm
    # _1password-gui  # TODO: need to move to /Applications after install, now it's broken
    utm
  ];
}
