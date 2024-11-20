{
  pkgs,
  user,
  ...
}: {
  system = {
    defaults = {
      dock = {
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/Music.app"
          "${pkgs.arc-browser}/Applications/Arc.app" # TODO: switch to nixpkgs
          "/Applications/Messenger.app" # TODO: switch to nixpkgs
          "${pkgs.teams}/Applications/Teams.app" # TODO: switch to nixpkgs
          "${pkgs.slack}/Applications/Slack.app"
          "${pkgs.vscodium}/Applications/VSCodium.app"
          "${pkgs.wezterm}/Applications/WezTerm.app"
          "/Applications/1Password.app" # TODO: move to /Applications
          "${pkgs.utm}/Applications/UTM.app"
        ];

        persistent-others = ["/Users/${user.name}/Downloads"];
      };
    };
  };
}
