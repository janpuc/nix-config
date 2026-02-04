{
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nil"
      "nix"
      "opencode"
    ];
    userSettings = {
      # ui_font_family = ".ZedSans";
      # terminal = {
      #   font_family = "JetBrainsMono Nerd Font";
      # };
      agent_servers = {
        OpenCode = {
          command = "opencode";
          args = [ "acp" ];
        };
      };
    };
  };
}
