{
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nil"
      "nix"
    ];
    userSettings = {
      # ui_font_family = ".ZedSans";
      # terminal = {
      #   font_family = "JetBrainsMono Nerd Font";
      # };
      context_servers = {
        osaurus = {
          command = "osaurus";
          args = [ "mcp" ];
        };
      };
    };
  };
}
