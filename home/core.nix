{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password # op cli tool
    alejandra # nix linter
    bat # modern replacement for cat
    gawk # gnu implementation of awk
    retry # helper for commands that can timeout
    saml2aws # login to aws using saml
    kubectl # kubernetes cli

    # Apps
    rectangle # window management
    lens # k8s gui
    # hidden-bar # hide menu bar icons TODO: not needed for now
    # factorio # factory game TODO: no for aarch64-darwin

    # arc-browser  # TODO: enable when it's fixed
    # messenger  # TODO: can't find it
    # teams  # TODO: only old teams available
    slack
    wezterm
    # _1password-gui  # TODO: need to move to /Applications after install, now it's broken
    utm
  ];
}
