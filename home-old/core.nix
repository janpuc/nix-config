# { pkgs, lib, ... }:
# {
#   home.packages = with pkgs; [
#     _1password-cli # op cli tool
#     alejandra # nix linter
#     bat # modern replacement for cat
#     gawk # gnu implementation of awk
#     retry # helper for commands that can timeout
#     saml2aws # login to aws using saml
#     kubectl # kubernetes cli
#     kubectx # k8s cluster switch
#     kubernetes-helm # k8s packages
#     kubebuilder # k8s development tools
#     just # easier makefile
#     mos # mouse utils
#     jq # json helper
#     yq # yaml helper
#     rsync
#     # rustc # rust stuff
#     # cargo # rust package stuff
#     rustup # rust stuff
#     # eksctl # eks cli
#     nodejs # nodejs runtime, includes npm
#     go # golang runtime
#     fzf # fuzzy finder
#     terraform
#     terragrunt # terraform on steroids
#     android-tools # for adb
#     nixos-rebuild

#     # Apps
#     raycast # replace spotlight
#     lens # k8s gui
#     prismlauncher # minecraft launcher
#     # hidden-bar # hide menu bar icons TODO: not needed for now
#     # factorio # factory game TODO: no for aarch64-darwin

#     teams
#     arc-browser # TODO: enable when it's fixed
#     # messenger  # TODO: can't find it
#     # teams  # TODO: only old teams available
#     slack
#     wezterm
#     _1password-gui # TODO: need to move to /Applications after install, now it's broken
#     utm
#     zoom-us
#   ];
# }
